// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log("Vite ⚡️ Rails");

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

console.log(
  "Visit the guide for more information: ",
  "https://vite-ruby.netlify.app/guide/rails",
);
import "core-js";
import "./controllers";
import AdditionalClaimantsUploadPage from "./pages/claims/AdditionalClaimantsUploadPage";

import { EtGdsDesignSystem } from "et_gds_design_system";
import "./stylesheets/application.scss";
import "@rails/ujs"
import ClaimantPage from "./pages/claims/ClaimantPage";
import AdditionalClaimantsPage from "./pages/claims/AdditionalClaimantsPage";
import RepresentativePage from "./pages/claims/RepresentativePage";
import RespondentPage from "./pages/claims/RespondentPage";
import AdditionalRespondentsPage from "./pages/claims/AdditionalRespondentsPage";
import EmploymentPage from "./pages/claims/EmploymentPage";
import ClaimTypePage from "./pages/claims/ClaimTypePage";
import ClaimConfirmationPage from "./pages/claims/ClaimConfirmationPage";
import SessionPrompt from "./components/SessionPrompt";
import RefundApplicantPage from "./pages/refunds/ApplicantPage";
import RefundFeesPage from "./pages/refunds/FeesPage";
import ClaimDetailsPage from "./pages/claims/ClaimDetailsPage";
import GuidesPage from "./pages/claims/GuidesPage";
EtGdsDesignSystem.initAll();
window.Et = {
  pages: {
    claims: {
      ClaimantPage: ClaimantPage,
      AdditionalClaimantsPage: AdditionalClaimantsPage,
      AdditionalClaimantsUploadPage: AdditionalClaimantsUploadPage,
      ClaimDetailsPage: ClaimDetailsPage,
      RepresentativePage: RepresentativePage,
      RespondentPage: RespondentPage,
      AdditionalRespondentsPage: AdditionalRespondentsPage,
      EmploymentPage: EmploymentPage,
      ClaimTypePage: ClaimTypePage,
      ClaimConfirmationPage: ClaimConfirmationPage,
      GuidesPage: GuidesPage,
    },
    refunds: {
      ApplicantPage: RefundApplicantPage,
      FeesPage: RefundFeesPage,
    },
  },
  components: {
    SessionPrompt,
  },
};

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'
