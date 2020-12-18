import RevealOnRadioButton from '../../components/RevealOnRadioButton'
export default function RespondentPage() {
  document.querySelectorAll('*[data-reveal-on-selector]').forEach(function(node) {
    const selector = node.attributes['data-reveal-on-selector'].value;
    const value = node.attributes['data-reveal-on-value'].value;
    RevealOnRadioButton(node, selector, value);
  });
};
