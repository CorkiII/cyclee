// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";
import { initMapbox } from '../plugins/init_mapbox';
import { initMapboxEdit } from '../plugins/init_mapbox_edit';
import { initMapboxShow } from '../plugins/init_mapbox_show';
import { initAutocomplete } from '../plugins/init_autocomplete';
import { initTimeOutHome } from '../plugins/init_timeouthome';
import { searchValidation } from '../components/search_validation';
import { dangerValidation } from '../components/danger_validation';
import { initMapboxParkings } from '../plugins/init_mapbox_parkings';
import { initMapboxPumps } from '../plugins/init_mapbox_pumps';
import { initMapboxRepairers } from '../plugins/init_mapbox_repairers';
import { closeModalHotspots } from '../plugins/close_modal_hotspots';

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
  $(".alert").delay(2000).slideUp(500, function(){
    $(".alert").alert('close');
  });
  initMapbox();
  initMapboxEdit();
  initMapboxShow();
  initAutocomplete();
  initTimeOutHome();
  searchValidation();
  if (document.querySelector("#new_danger")) {
    dangerValidation();
  }
  initMapboxParkings();
  initMapboxPumps();
  initMapboxRepairers();
  closeModalHotspots();
});
