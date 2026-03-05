/**
 * Privacy Shield by Zovo — Popup Script
 *
 * Queries the background service worker for blocked-request counts
 * and manages the enable/disable toggle via chrome.storage.
 */

document.addEventListener("DOMContentLoaded", init);

async function init() {
  const tabCountEl = document.getElementById("tab-count");
  const sessionCountEl = document.getElementById("session-count");
  const toggleEl = document.getElementById("toggle");
  const statusTextEl = document.getElementById("status-text");

  // ------------------------------------------------------------------
  // 1. Restore saved enabled state
  // ------------------------------------------------------------------
  const { enabled } = await chrome.storage.local.get("enabled");
  const isEnabled = enabled !== false; // default to true
  toggleEl.checked = isEnabled;
  updateStatusText(isEnabled);

  // ------------------------------------------------------------------
  // 2. Fetch blocked counts from the background service worker
  // ------------------------------------------------------------------
  try {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    if (tab) {
      chrome.runtime.sendMessage(
        { type: "getStats", tabId: tab.id },
        (response) => {
          if (response) {
            animateCount(tabCountEl, response.tabCount);
            animateCount(sessionCountEl, response.sessionTotal);
          }
        }
      );
    }
  } catch (err) {
    // Gracefully handle — counts stay at 0
    console.warn("Privacy Shield: could not fetch stats", err);
  }

  // ------------------------------------------------------------------
  // 3. Toggle handler
  // ------------------------------------------------------------------
  toggleEl.addEventListener("change", async () => {
    const nowEnabled = toggleEl.checked;

    // Persist preference
    await chrome.storage.local.set({ enabled: nowEnabled });

    // Tell background to enable/disable the ruleset
    chrome.runtime.sendMessage(
      { type: "setEnabled", enabled: nowEnabled },
      (response) => {
        if (response && !response.success) {
          console.error("Privacy Shield: toggle failed", response.error);
        }
      }
    );

    updateStatusText(nowEnabled);
  });

  // ------------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------------

  /**
   * Update the status label beside the toggle.
   */
  function updateStatusText(on) {
    statusTextEl.textContent = on ? "Protection Active" : "Protection Paused";
    statusTextEl.classList.toggle("disabled", !on);
  }

  /**
   * Format large numbers for display (e.g. 1234 -> "1,234").
   */
  function formatNumber(n) {
    return Number(n).toLocaleString();
  }

  /**
   * Animate a count from 0 to the target number.
   * Completes in roughly 400ms with eased steps.
   */
  function animateCount(el, target) {
    const num = Number(target) || 0;
    if (num === 0) {
      el.textContent = "0";
      return;
    }
    const duration = 400;
    const steps = Math.min(num, 30);
    const stepTime = duration / steps;
    let current = 0;
    const increment = num / steps;

    const timer = setInterval(() => {
      current += increment;
      if (current >= num) {
        clearInterval(timer);
        el.textContent = formatNumber(num);
      } else {
        el.textContent = formatNumber(Math.floor(current));
      }
    }, stepTime);
  }
}
