import Spotlight from 'spotlight.js';

import '../css/app.css';

import 'phoenix_html';

const $ = document.querySelector.bind(document);
const stepsContainer = $('.js-step-container');
const stepsContainer2 = $('#recipe_steps_container');
const addStepButton = $('.js-add-step')

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
      recalcStepNumbers();

      addStepButton.style.display = 'block';
    }

    if (targetClassList.contains('js-add-step')) {
      addItem();
      recalcStepNumbers();

      console.log(stepsContainer2.childNodes.length, e.target)

      if (stepsContainer2.childNodes.length >= 10) {
        addStepButton.style.display = 'none';
      }
    }
  });

  recalcStepNumbers();
}


(function () {
  const ingContainer = $('.js-ing-container')
  const addIngredientBtn = $('.js-add-ingredient');


  const addIng = () => {
    const firstItem = $('.js-ingredient').cloneNode(true);
    ingContainer.append(firstItem);


  };


  ingContainer.addEventListener('click', e => {
    e.preventDefault();
    const targetClassList = e.target.classList;
    if (targetClassList.contains('js-add-ingredient')) {
      addIng();
    }


  });


})()
