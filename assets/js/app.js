import '../css/app.css';

import 'phoenix_html';

const stepsContainer = document.querySelector('.js-step-container');
const stepsContainer2 = document.querySelector('#recipe_steps_container');


const addItem = () => {
  const firstItem = stepsContainer.querySelector('li').cloneNode(true);
  firstItem.querySelector('textarea').value = ''
  stepsContainer2.append(firstItem);
};

const removeItem = (removeButton) => {
  removeButton.closest('li').remove();
};

const recalcStepNumbers = () => {
  Array.from(stepsContainer.querySelectorAll('label')).forEach((label, idx) => {
    label.textContent = `Step ${idx + 1}`
  })
}


if (stepsContainer) {
  stepsContainer.addEventListener('click', e => {
    e.preventDefault();
    const targetClassList = e.target.classList;

    if (targetClassList.contains('js-remove-step')) {
      removeItem(e.target);
      recalcStepNumbers()

    }

    if (targetClassList.contains('js-add-step')) {
      addItem();
      recalcStepNumbers();
    }
  });

  recalcStepNumbers();
}
