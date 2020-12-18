import RevealOnRadioButton from '../../components/RevealOnRadioButton'
import RemoveMultiple from "../../components/RemoveMultiple";

function setupReveal(node) {
  document.querySelectorAll('*[data-reveal-on-selector]').forEach(function(node) {
    const selector = node.attributes['data-reveal-on-selector'].value;
    const value = node.attributes['data-reveal-on-value'].value;
    RevealOnRadioButton(node, selector, value);
  });
}

function setupRemoveMultiple() {
  RemoveMultiple();
}

export default function AdditionalClaimantsPage() {
  setupReveal();
  setupRemoveMultiple();
};
