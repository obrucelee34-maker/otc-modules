-- chunkname: @/modules/client_styles/styles.lua

local fonts = {
	"arial",
	"baby",
	"cambria",
	"constantia",
	"helvetica",
	"khmer",
	"lato",
	"montserrat",
	"myriad",
	"nueva",
	"optimus",
	"roboto",
	"sans",
	"terminus",
	"verdana",
	"myriad-pro",
	"myriad-pro-semibold",
	"eras",
	"myriad-pro-bordered",
	"myriad-pro-semibold-bordered",
	"critical",
	"saira-stencil-one",
	"poppins",
	"poppins-semibold",
	"vollkorn",
	"mirza-medium",
	"poppins-bold-bordered",
	"poppins-semibold-bordered",
	"poppins-semibold-shadow",
	"vollkorn-sc-bold",
	"vollkorn-sc-bold-bordered",
	"poppins-heavy-bordered"
}

function init()
	local files

	files = g_resources.listDirectoryFiles("/styles")

	for _, file in pairs(files) do
		if g_resources.isFileType(file, "otui") then
			g_ui.importStyle("/styles/" .. file)
		end
	end

	for _, directory in pairs(fonts) do
		local files = g_resources.listDirectoryFiles("/fonts/" .. directory)

		for _, file in pairs(files) do
			if g_resources.isFileType(file, "otfont") then
				g_fonts.importFont("/fonts/" .. directory .. "/" .. file)
			end
		end
	end

	g_mouse.loadCursors("/cursors/cursors")
	g_fonts.setDefaultFont("poppins-12")
	g_hud.init()
end

function terminate()
	return
end
