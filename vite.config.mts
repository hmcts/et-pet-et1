import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import FullReload from "vite-plugin-full-reload";
import StimulusHMR from "vite-plugin-stimulus-hmr";
import path from "path";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(["config/routes.rb", "app/views/**/*", "app/helpers/**/*"]),
    StimulusHMR(),
    myPlugin(),
  ],
  define: {
    $: "jQuery",
    jQuery: "jQuery",
  },
});
function myPlugin() {
  return {
    name: "my-plugin",
    config: (config) => {
      // Ensure resolve and alias objects exist
      config.resolve = config.resolve || {};
      config.resolve.alias = config.resolve.alias || {};

      // Add your alias
      config.resolve.alias["@govuk-assets"] = path.resolve(
        __dirname,
        "node_modules/govuk-frontend/dist/govuk/assets",
      );

      return config; // Return the modified config
    },
  };
}
