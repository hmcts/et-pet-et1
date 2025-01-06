require "rails_helper"

RSpec.describe MarkdownRenderer, type: :service do

  let(:html_renderer) { instance_double(Redcarpet::Render::HTML) }

  before do
    allow(Redcarpet::Render::HTML).to receive(:new).and_return html_renderer
  end

  describe "initialize" do
    it "setups a Reccarpet markdown renderer with the table option" do
      expect(Redcarpet::Markdown).to receive(:new).with(html_renderer, tables: true)
      described_class.new
    end
  end

  describe "#render" do

    let(:content_arg)         { "such render.." }
    let(:html_safe_content)   { "so html safe.." }
    let(:redcardpet_markdown) { instance_double(Redcarpet::Markdown, render: rendered_content) }
    let(:rendered_content)    { instance_double(String, html_safe: html_safe_content) }

    before do
      allow(Redcarpet::Markdown).to receive(:new).and_return redcardpet_markdown
    end

    it { expect(described_class.new.render(content_arg)).to eq html_safe_content }

    it "proxies the contents through the renderer" do
      expect(redcardpet_markdown).to receive(:render).with content_arg

      described_class.new.render(content_arg)
    end

    it "returning a html safe string" do
      expect(rendered_content).to receive(:html_safe)

      described_class.new.render(content_arg)
    end
  end
end
