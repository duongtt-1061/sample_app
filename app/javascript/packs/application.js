//= require jquery
//= require jquery_ujs
//= require i18n
//= require jquery.turbolinks
//= require i18n/translations

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('bootstrap')
require('packs/custom')


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
