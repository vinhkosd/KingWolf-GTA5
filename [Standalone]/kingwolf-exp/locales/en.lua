Locales = {}
Locales["en"] = {
    ['err_xp_update']       = "^1kingwolf-exp ERROR: ^7`Invalid XP (%s) passed to '%s'",
    ['err_lvl_update']      = "^1kingwolf-exp ERROR: ^7`Invalid Rank (%s) passed to '%s'",
    ['err_lvls_check']      = "^1kingwolf-exp ERROR: ^7`You have an error in %s rank(s) in '%s'",
    ['err_type_check']      = "^1kingwolf-exp ERROR: ^7`%s should be of the type: `%s`",
    ['err_id_check']        = "^1kingwolf-exp ERROR: ^7`Invalid playerId",
    ['err_lvl_check']       = "Rank %s: %s",
    ['err_invalid_player']  = "Invalid playerId",
    ['err_invalid_rank']    = "Invalid Rank (Minimum Rank = 1, Maximum Rank = %s)",
    ['err_invalid_type']    = "%s should be of the type: `%s`",

    ['cmd_current_xp']  = "Bạn đang có ^*^2 %s EXP",
    ['cmd_current_lvl'] = "Cấp của bạn: ^*^2 %s",
    ['cmd_next_lvl']    = "Bạn cần ^*^2 %s EXP ^*^7 để lên cấp ^*^2 %s",
    ['cmd_give_desc']   = "Give EXP to player",
    ['cmd_take_desc']   = "Take XP from player",
    ['cmd_set_desc']    = "Set player's XP",
    ['cmd_rank_desc']   = "Set player's Rank",
    ['cmd_xp_amount']   = "The amount of XP",
    ['cmd_rank_amount'] = "The rank to set",
    ['cmd_playerid']    = "The ID of the player",

    ['err_db_user']     = "^1kingwolf-exp ERROR: ^7`users` table missing from database. Did you import `es_extended.sql` from es_extended?",
    ['err_db_columns']  = "^1kingwolf-exp ERROR: ^7`rp_xp` / `rp_rank` columns missing from `users` table. Did you import `kingwolf-exp.sql`?",
}

function _(str, ...)  -- Translate string

	if Locales[Config.Locale] ~= nil then

		if Locales[Config.Locale][str] ~= nil then
			return string.format(Locales[Config.Locale][str], ...)
		else
			return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.Locale .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end