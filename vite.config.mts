import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import FullReload from "vite-plugin-full-reload";
import StimulusHMR from "vite-plugin-stimulus-hmr";
import EtGdsDesignSystemPlugin from "et_gds_design_system/vite-plugin";
import path from "path";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(["config/routes.rb", "app/views/**/*", "app/helpers/**/*"]),
    StimulusHMR(),
    EtGdsDesignSystemPlugin(),
  ],
  define: {
    $: "jQuery",
    jQuery: "jQuery",
  },
});
