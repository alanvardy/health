// We need to import the CSS so that webpack will load it via MiniCssExtractPlugin.
import css from "../css/app.scss"

import $ from "jquery"

window.jQuery = $;
window.$ = $;

import "bootstrap"
import "phoenix_html"

import { Socket } from "phoenix"
