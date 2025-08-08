-- chunkname: @/modules/game_damage_numbers/damage_numbers.lua

g_damageNumbers = {
	screenshotMode = false,
	default = {
		fonts = {
			"baby-14",
			"baby-20",
			"baby-26",
			"baby-32",
			"critical"
		},
		offset = {
			y = 25,
			x = 25
		},
		speed = {
			y = 36,
			x = 25
		}
	},
	screenshot = {
		fonts = {
			"baby-12",
			"baby-12",
			"baby-12",
			"baby-12",
			"critical"
		},
		offset = {
			y = 12,
			x = 12
		},
		speed = {
			y = 18,
			x = 12
		}
	}
}

function g_damageNumbers.init()
	connect(g_map, {
		onAnimatedText = g_damageNumbers.onAnimatedText,
		onDamageText = g_damageNumbers.onDamageText
	})
end

function g_damageNumbers.terminate()
	disconnect(g_map, {
		onAnimatedText = g_damageNumbers.onAnimatedText,
		onDamageText = g_damageNumbers.onDamageText
	})
end

function g_damageNumbers.setScreenshotMode(setOn)
	g_damageNumbers.screenshotMode = setOn
end

function g_damageNumbers.onAnimatedText(widget, text)
	if g_damageNumbers.screenshotMode and not widget:isDamageText() then
		widget:setOffset({
			y = 1000,
			x = 1000
		})
	end
end

function g_damageNumbers.onDamageText(widget, text)
	local screenshotMode = g_damageNumbers.screenshotMode
	local screenshot = g_damageNumbers.screenshot
	local default = g_damageNumbers.default
	local fonts = screenshotMode and screenshot.fonts or default.fonts
	local offsetx = screenshotMode and screenshot.offset.x or default.offset.x
	local offsety = screenshotMode and screenshot.offset.y or default.offset.y
	local speedx = screenshotMode and screenshot.speed.x or default.speed.x
	local speedy = screenshotMode and screenshot.speed.y or default.speed.y
	local impact = widget:getImpact()
	local isCritical = impact == 500
	local mode = widget:getMode()
	local type = widget:getType()
	local impactIndex = isCritical and 5 or FishFight.gameState == 1 and (FishFight.bigNumbers and 3 or 1) or math.min(4, math.floor(math.max(1, impact / 25 - 1)))

	type = mode == TextTypes.TextTypeDamageReceived and MessageTypeDamageReceived or type

	local color = MessageColors[type]

	widget:setFont(fonts[impactIndex])
	widget:setAnimationSpeed({
		x = math.random(-speedx, speedx),
		y = math.min(3, impactIndex) * speedy
	})
	widget:setColorEx(color)
	widget:setOffset({
		x = math.random(-offsetx, offsetx),
		y = math.random(-offsety, offsety)
	})

	if mode ~= TextTypes.TextTypeDamageReceived and text:startswith("-") then
		text = text:sub(2)
	end

	if isCritical then
		text = string.format("@%s", text)
	end

	widget:setText(text)

	local amount = math.min(3, impactIndex - 1)
	local intensity = math.min(3, impactIndex - 2)
	local speed = 50
	local pause = 0
	local direction = 1
	local sendScreenShake = (mode == MessageDamageDealed or mode == MessageDamageReceived) and mode ~= MessageHeal and mode ~= MessageHealOthers

	if impact >= 150 and sendScreenShake and g_settings.getBoolean("screenShake") then
		modules.game_interface.getMapPanel():shake(amount, intensity, speed, pause, direction)
	end
end
