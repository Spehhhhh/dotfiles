// General settings
const EXCLUDED_DOMAINS = /roamresearch\.com|notion\.so|feishu\.cn|kagi\.com/i;
const TIMEOUT = 10000;

settings.tabsThreshold = 0;                // Always use omnibar for tab selection
settings.focusAfterClosed = 'last';        // Focus last viewed tab when closing current tab
settings.focusFirstCandidate = true;       // Focus first item in omnibar
settings.hintAlign = 'left';               // Align link hints to the left
settings.modeAfterYank = 'Normal';         // Return to Normal mode after yanking
settings.omnibarPosition = 'bottom';
settings.omnibarMaxResults = 5;
// settings.digitForRepeat = false;

api.Hints.style(`
  font-family: MonoLisa Nerd Font;
`);
settings.theme = `
.sk_theme #sk_omnibarSearchArea input, #sk_omnibarSearchResult {
  font-size: 14px;
}
`;

// Search engine configuration
const SEARCH_ENGINE = 'https://kagi.com/search?q=';
api.addSearchAlias('k', 'kagi', SEARCH_ENGINE, 's');
settings.defaultSearchEngine = 'k';

// Scrolling controls
api.mapkey('<Ctrl-d>', 'Scroll down half page', function () {
  api.Normal.scroll('pageDown');
});
api.mapkey('<Ctrl-u>', 'Scroll up half page', function () {
  api.Normal.scroll('pageUp');
});

// URL and clipboard operations
api.mapkey('ym', 'Copy current page URL as Markdown link', function () {
  api.Clipboard.write('[' + document.title + '](' + window.location.href + ')');
});

// URL validation pattern
// Matches: domain.com, sub.domain.com, http(s)://domain.com, with optional path
const URL_PATTERN = /^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*\/?$/;

// Error handling for clipboard operations
function handleClipboardError(error) {
  api.Front.showBanner(`Failed to access clipboard: ${error.message}`, 3000);
}

/**
 * Process clipboard text and open as URL or search
 * @param {string} clipText - Text from clipboard
 * @param {boolean} openInNewTab - Whether to open in new tab
 */
function processClipboardText(clipText, openInNewTab = false) {
  try {
    const markInfo = {
      scrollLeft: 0,
      scrollTop: 0,
      tab: {
        tabbed: openInNewTab,
        active: openInNewTab
      }
    };

    // If text is a valid URL, open it directly (adding https:// if needed)
    // Otherwise, use it as a search query
    if (URL_PATTERN.test(clipText)) {
      markInfo.url = clipText.startsWith('http') ? clipText : `https://${clipText}`;
    } else {
      markInfo.url = `${SEARCH_ENGINE}${encodeURIComponent(clipText)}`;
    }

    api.RUNTIME("openLink", markInfo);
  } catch (error) {
    handleClipboardError(error);
  }
}

// Clipboard URL opening mappings
api.mapkey('go', 'Open URL in clipboard', function () {
  api.Clipboard.read((response) => {
    if (response && response.data) {
      processClipboardText(response.data.trim(), false);
    } else {
      handleClipboardError(new Error('No content in clipboard'));
    }
  });
});

api.mapkey('gO', 'Open URL in clipboard in new tab', function () {
  api.Clipboard.read((response) => {
    if (response && response.data) {
      processClipboardText(response.data.trim(), true);
    } else {
      handleClipboardError(new Error('No content in clipboard'));
    }
  });
});

// PassThrough mode
api.mapkey('p', 'Enter PassThrough mode', function () {
  const seconds = TIMEOUT / 1000;
  api.Front.showBanner(
    `Entering PassThrough mode for ${seconds}s, press ESC to exit early`,
    1000
  );
  api.Normal.passThrough(TIMEOUT);
});

// Unmap
api.iunmap(':');

// Keep only essential mappings for specific sites
api.unmapAllExcept([
  // Scrolling
  '<Ctrl-d>', '<Ctrl-u>', 'e', 'd',
  // Navigation
  'E', 'R',
  // Tabs
  'S', 'D', 'x', 'X', 't', 'T', 'B',
  // Misc
  'F', 'i', 'p'
], EXCLUDED_DOMAINS);

api.map('<Space><Space>', 'T');

// Choose a buffer/tab
// api.map('b', 'T');

// Open a URL in current tab
// api.map('o', 'go');

// Edit current URL, and open in same tab
// api.map('O', ';U');

// Edit current URL, and open in new tab
// api.map('T', ';u');
