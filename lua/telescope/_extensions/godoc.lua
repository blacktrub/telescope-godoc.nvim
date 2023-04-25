return require("telescope").register_extension({
	exports = {
		godoc = require("godoc").picker,
	},
})
