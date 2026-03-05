/**
 * Privacy Shield by Zovo — Background Service Worker
 *
 * Tracks blocked requests per tab using the declarativeNetRequestFeedback
 * API and exposes counts to the popup via chrome.runtime messaging.
 */

// ---------------------------------------------------------------------------
// State: per-tab blocked request counters and session total
// ---------------------------------------------------------------------------
const blockedCounts = {};   // { tabId: count }
let sessionTotal = 0;

// ---------------------------------------------------------------------------
// Listen for matched declarativeNetRequest rules
// ---------------------------------------------------------------------------
chrome.declarativeNetRequest.onRuleMatchedDebug?.addListener((info) => {
  const tabId = info.request.tabId;
  if (tabId < 0) return; // ignore requests not tied to a tab

  blockedCounts[tabId] = (blockedCounts[tabId] || 0) + 1;
  sessionTotal++;

  // Update the badge for this tab
  updateBadge(tabId);
});

/**
 * Update the extension badge text with the blocked count for a tab.
 */
function updateBadge(tabId) {
  const count = blockedCounts[tabId] || 0;
  const text = count > 999 ? "999+" : String(count);

  chrome.action.setBadgeText({ text, tabId });
  chrome.action.setBadgeBackgroundColor({ color: "#00cc00", tabId });
}

// ---------------------------------------------------------------------------
// Clean up when a tab is removed
// ---------------------------------------------------------------------------
chrome.tabs.onRemoved.addListener((tabId) => {
  delete blockedCounts[tabId];
});

// ---------------------------------------------------------------------------
// Messaging: respond to popup queries
// ---------------------------------------------------------------------------
chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
  if (message.type === "getStats") {
    // Return counts for the requested tab and the session total
    const tabCount = blockedCounts[message.tabId] || 0;
    sendResponse({ tabCount, sessionTotal });
  }
  // Return true only if we plan to respond asynchronously (we don't here)
  return false;
});

// ---------------------------------------------------------------------------
// Toggle blocking on/off via dynamic rule enable/disable
// ---------------------------------------------------------------------------
chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
  if (message.type === "setEnabled") {
    const enabled = message.enabled;

    // Enable or disable the static ruleset
    chrome.declarativeNetRequest.updateEnabledRulesets({
      enableRulesetIds: enabled ? ["tracker_rules"] : [],
      disableRulesetIds: enabled ? [] : ["tracker_rules"]
    }).then(() => {
      sendResponse({ success: true });
    }).catch((err) => {
      sendResponse({ success: false, error: err.message });
    });

    // Return true to indicate async sendResponse
    return true;
  }
  return false;
});

// ---------------------------------------------------------------------------
// On install: initialise storage defaults
// ---------------------------------------------------------------------------
chrome.runtime.onInstalled.addListener(() => {
  chrome.storage.local.set({ enabled: true });
});
