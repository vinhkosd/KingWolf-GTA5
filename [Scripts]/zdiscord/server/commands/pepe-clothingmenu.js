/**
 * This file is part of zdiscord.
 * Copyright (C) 2021 Tony/zfbx
 * source: <https://github.com/zfbx/zdiscord>
 *
 * This work is licensed under the Creative Commons
 * Attribution-NonCommercial-ShareAlike 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/
 * or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
 */

module.exports = {
    name: "clothing-menu",
    description: "Bật menu quần áo cho người chơi",
    default_permission: false,
    role: "admin",

    options: [
        {
            name: "id",
            description: "Player's current id",
            required: true,
            type: "INTEGER",
        },
    ],

    run: async (client, interaction, args) => {
        if (!GetPlayerName(args.id)) return interaction.reply({ content: "ID Người chơi không hợp lệ.", ephemeral: true });
        emitNet("pepe-clothing:client:openMenu", args.id);
        client.utils.log.info(`[${interaction.member.displayName}] gave ${args.id} the clothing menu`);
        return interaction.reply({ content: `${GetPlayerName(args.id)} (${args.id}) đã mở menu quần áo`, ephemeral: false });
    },
};
