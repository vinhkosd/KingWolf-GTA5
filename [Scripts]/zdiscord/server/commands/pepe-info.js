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
    name: "info",
    description: "Get Info a player from the city",
    default_permission: false,
    role: "mod",

    options: [
        {
            name: "id",
            description: "Player's current id",
            required: true,
            type: "INTEGER",
        }
    ],

    run: async (client, interaction, args) => {
        if (!GetPlayerName(args.id)) return interaction.reply({ content: "ID Người chơi không hợp lệ.", ephemeral: true });
        
        const player = client.Framework.Functions.GetPlayer(args.id);
        let duty = "Hết ca"
        if (player.PlayerData.job.onduty) {
            duty = "Trong ca"
        }
        
        let grade = (player.PlayerData.job.grade != null && player.PlayerData.job.grade.name != null) ? player.PlayerData.job.grade.name : 'No Grades'
        if(player != null) {
            const embed = new client.Embed()
            .setColor(client.config.embedColor)
            .setTitle(`Thông tin player ${GetPlayerName(args.id)}`)
            .setFooter("");
            let desc = "";
            for (const [key, value] of Object.entries(client.utils.getPlayerIdentifiers(args.id))) {
                if (key == "discord") desc += `**${key}:** <@${value}> (${value})\n`;
                else desc += `**${key}:** ${value}\n`;
            }
            desc += "\n";
            desc += `**Tiền mặt:** ${player.PlayerData.money.cash}\n`;
            desc += `**Ngân hàng:** ${player.PlayerData.money.bank}\n`;
            desc += `**Họ tên in-game:** ${player.PlayerData.charinfo.firstname + " " + player.PlayerData.charinfo.lastname}\n`;
            desc += `**Ngày sinh:** ${player.PlayerData.charinfo.birthdate}\n`;
            desc += `**Giới tính:** ${player.PlayerData.charinfo.gender == 1 ? "Nữ" : "Nam"}\n`;
            desc += `**Nghề nghiệp:** ${player.PlayerData.job.label} [${duty}] | ${grade}\n`;
            embed.setDescription(desc);
            client.utils.log.info(`[${interaction.member.displayName}] check thông tin người chơi ${GetPlayerName(args.id)} (${args.id})`);
            return interaction.reply({ embeds: [embed], ephemeral: true }).catch();
        } else {
            return interaction.reply({ content: "Người chơi chưa chọn nhân vật.", ephemeral: true });
        }
    },
};
