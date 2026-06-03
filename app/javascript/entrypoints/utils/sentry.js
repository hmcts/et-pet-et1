import * as Sentry from "@sentry/browser";
import { escapeRegExp } from "./regexp";
function initSentry() {
  try {
    const sentryMeta = document.querySelector("meta[name='sentry-public-dsn']");

    if (sentryMeta) {
      const sentryData = JSON.parse(
        document.querySelector("meta[name='sentry-data']").content,
      );
      const origin = escapeRegExp(window.location.origin);
      Sentry.init({
        dsn: sentryMeta.content,
        // Setting this option to true will send default PII data to Sentry.
        // For example, automatic IP address collection on events
        sendDefaultPii: true,
        release: sentryData.release,
        allowUrls: [new RegExp(`^${origin}/`)],
      });
      Sentry.setUser({ id: sentryData.userId });
      Sentry.setExtras({
        case_number: sentryData.caseNumber,
        store_id: sentryData.storeId,
      });
      Sentry.setTags({
        case_number: sentryData.caseNumber,
      });
    }
  } catch (error) {
    console.error("Failed to configuure Sentry context", error);
    Sentry.captureException(error, { tags: { area: "sentry_setup" } });
  }
}

export { initSentry };
