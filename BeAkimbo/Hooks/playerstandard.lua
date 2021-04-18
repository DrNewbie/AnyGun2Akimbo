function PlayerStandard:is_BEAKIMBO_goldeneye_weapon()
    local weapon_name_id = managers.player:equipped_weapon_unit():base():get_name_id()
    local is_goldeneye_reload = tweak_data.weapon[weapon_name_id] and tweak_data.weapon[weapon_name_id].animations.akimbo_goldeneye_reload
    return is_goldeneye_reload
end

Hooks:PostHook(PlayerStandard, "_start_action_reload", "BEAKIMBO_reload_start_action_reload", function(self, t)
    local weapon = self._equipped_unit:base()
    if weapon and weapon:can_reload() and self:is_BEAKIMBO_goldeneye_weapon() then
        self:_stance_entered()
    end
end)

Hooks:PreHook(PlayerStandard, "_start_action_reload", "BEAKIMBO_update_reload_timers_Pre", function(self, t)
    local is_reload_interrupted = self._queue_reload_interupt
    local is_reload_over_shotgun = self._state_data.reload_exit_expire_t and self._state_data.reload_exit_expire_t <= t
    local is_reload_over_normal = self._state_data.reload_expire_t and self._state_data.reload_expire_t <= t or is_reload_interrupted
    local is_goldeneye_reload = self:is_BEAKIMBO_goldeneye_weapon()
    local reset_stance = (is_reload_interrupted or is_reload_over_normal or is_reload_over_shotgun)and is_goldeneye_reload
	self.__BEAKIMBO_reset_stance = true
end)

Hooks:PostHook(PlayerStandard, "_start_action_reload", "BEAKIMBO_update_reload_timers_Post", function(self, ...)
    if self.__BEAKIMBO_reset_stance then
		self.__BEAKIMBO_reset_stance = false
        self:_stance_entered()
    end
end)