require('normalize.css');
require('./styles/main.css');

const Elm = require('../elm/Main');
const app = Elm.Main.embed(document.getElementById('app'));
