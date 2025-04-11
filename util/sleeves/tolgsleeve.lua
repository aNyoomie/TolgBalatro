CardSleeves.Sleeve {
    key = 'tolg',
    unlocked = false,
    unlock_condition = { deck = "b_tolg_tolgdeck", stake = "stake_white" },
    atlas = 'tolgSleeves',
    pos = {
        x = 0,
        y = 0,
    },
    config = {},
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() == "b_tolg_tolgdeck" then
            key = self.key .. '_alt'
            self.config = {vouchers = {'v_tolg_embolden'},consumables = {'c_tolg_badge'}}
            for _, voucher in pairs(self.config.vouchers) do
                vars[#vars+1] = localize{type = 'name_text', key = voucher, set = 'Voucher'}
            end
        else
            key = self.key
            self.config = {vouchers = {'v_tolg_bless'},consumables = {'c_tolg_sending'}}
            for _, voucher in pairs(self.config.vouchers) do
                vars[#vars+1] = localize{type = 'name_text', key = voucher, set = 'Voucher'}
            end
        end
        return { key = key, vars = vars }
    end,
}

-- sleeve_buf_jstation