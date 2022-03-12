import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require("jquery")
import "bootstrap"


Rails.start()
Turbolinks.start()
ActiveStorage.start()

import I18n from "../i18n-js/index.js.erb"
window.I18n = I18n
