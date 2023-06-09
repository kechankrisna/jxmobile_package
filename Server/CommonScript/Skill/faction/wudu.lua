
local tb    = {
    wudu_pg1 = --五毒笛咒-普攻1式--20级
    { 
		attack_attackrate_v={{{1,100},{20,100},{30,100},{32,100}}},
	--	attack_usebasedamage_p={{{1,40},{20,70},{30,100},{32,120}}},
	--	attack_wooddamage_v={
	--		[1]={{1,30*1},{20,130*0.95},{30,300*0.95},{32,350*0.95}},
	--		[3]={{1,30*1},{20,130*1.05},{30,300*1.05},{32,350*1.05}}
	--		},
		dotdamage_wood={{{1,4},{20,10},{30,12},{32,13}},{{1,5},{20,30},{30,100},{32,120}},15*0.5},  	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		skill_statetime={{{1,15*6},{15,15*6},{16,15*6}}},							--毒的持续时间
		userdesc_109={{{1,13},{15,13},{16,13}}},											--描述用，显示毒的次数
		skill_dot_ext_type={1},															--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		state_npchurt_attack={100,7},
		missile_hitcount={{{1,2},{20,2},{30,2},{32,2}}},
    }, 
    wudu_pg2 = --五毒笛咒-普攻2式--20级
    { 
		attack_attackrate_v={{{1,100},{20,100},{30,100},{32,100}}},
	--	attack_usebasedamage_p={{{1,40},{20,70},{30,110},{32,120}}},
	--	attack_wooddamage_v={
	--		[1]={{1,30*1},{20,140*0.95},{30,300*0.95},{32,350*0.95}},
	--		[3]={{1,30*1},{20,140*1.05},{30,300*1.05},{32,350*1.05}}
	--		},
		dotdamage_wood={{{1,4},{20,10},{30,12},{32,13}},{{1,5},{20,30},{30,150},{32,170}},15*0.5},  	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		skill_statetime={{{1,15*6},{15,15*6},{16,15*6}}},							--毒的持续时间
		skill_dot_ext_type={1},															--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		state_npchurt_attack={100,7},
		missile_hitcount={{{1,2},{20,2},{30,2},{32,2}}},
    }, 
    wudu_pg3 = --五毒笛咒-普攻3式--20级
    { 
		attack_attackrate_v={{{1,100},{20,100},{30,100},{32,100}}},
	--	attack_usebasedamage_p={{{1,60},{20,80},{30,110},{32,120}}},
	--	attack_wooddamage_v={
	--		[1]={{1,60*1},{20,180*0.95},{30,350*0.95},{32,400*0.95}},
	--		[3]={{1,60*1},{20,180*1.05},{30,350*1.05},{32,400*1.05}}
	--		},
		dotdamage_wood={{{1,5},{20,12},{30,14},{32,15}},{{1,5},{20,40},{30,150},{32,170}},15*0.5},  	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		skill_statetime={{{1,15*6},{15,15*6},{16,15*6}}},							--毒的持续时间
		skill_dot_ext_type={1},															--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		state_npchurt_attack={100,7},
		missile_hitcount={{{1,3},{20,3},{30,3},{32,3}}},
    }, 
    wudu_pg4 = --五毒笛咒-普攻4式--20级
    { 
		attack_attackrate_v={{{1,100},{20,100},{30,100},{32,100}}},
--		attack_usebasedamage_p={{{1,80},{20,130},{30,170},{32,180}}},
--		attack_wooddamage_v={
--			[1]={{1,90*1},{20,300*0.95},{30,500*0.95},{32,550*0.95}},
--			[3]={{1,90*1},{20,300*1.05},{30,500*1.05},{32,550*1.05}}
--			},
		dotdamage_wood={{{1,6},{20,13},{30,16},{32,18}},{{1,5},{20,60},{30,200},{32,220}},15*0.5},  	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		skill_statetime={{{1,15*6},{15,15*6},{16,15*6}}},							--毒的持续时间
		skill_dot_ext_type={1},															--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		state_zhican_attack={{{1,40},{20,40},{30,40},{32,40}},{{1,15*0.5},{20,15*0.5},{30,15*0.5},{32,15*0.5}}},
		state_npchurt_attack={100,7},
		missile_hitcount={{{1,4},{20,4},{30,4},{32,4}}},
    }, 
    wudu_yfsg = --阴风蚀骨-1级主动--15级
    { 
--		attack_usebasedamage_p={{{1,150},{15,240},{16,250}}},
--		attack_wooddamage_v={
--			[1]={{1,200*0.9},{15,600*0.9},{16,700*0.9}},
--			[3]={{1,200*1.1},{15,600*1.1},{16,700*1.1}}
--			},
		dotdamage_wood={{{1,15},{15,30},{16,32},{20,35},{21,37}},{{1,50},{15,150},{16,170},{20,220},{21,250}},15*0.5}, 	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		skill_statetime={{{1,15*6},{15,15*6},{16,15*6},{21,15*6}}},										--毒的持续时间
		userdesc_109={{{1,13},{15,13},{16,13},{21,13}}},												--描述用，显示毒的次数
		skill_dot_ext_type={1},															--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		state_zhican_attack={{{1,100},{15,100},{16,100},{21,100}},{{1,15*1.5},{15,15*1.5},{16,15*1.5},{21,15*1.5}}},
    },	
    wudu_zhdc = --召唤毒虫-4级主动2--15级
    { 
		--skill_randskill1={{{1,20},{10,20}},4312,{{1,1},{10,10},{21,21}}},	--权值，技能ID，等级
		--skill_randskill2={{{1,20},{10,20}},4314,{{1,1},{10,10},{21,21}}},	--权值，技能ID，等级
		--skill_randskill3={{{1,20},{10,20}},4316,{{1,1},{10,10},{21,21}}},	--权值，技能ID，等级
		--skill_randskill4={{{1,20},{10,20}},4318,{{1,1},{10,10},{21,21}}},	--权值，技能ID，等级
		--skill_randskill5={{{1,20},{10,20}},4320,{{1,1},{10,10},{21,21}}},	--权值，技能ID，等级
		userdesc_000={4313},
		userdesc_101={100,15*2},					--描述用：灵蛇造致缠，对应wudu_zhdc_ls_skill		
		userdesc_102={-300},						--描述用：碧蟾降木抗，对应wudu_zhdc_bc_skill		
		userdesc_103={{{1,5},{10,30},{11,33}}},		--描述用：赤蝎增加主角会心伤害,wudu_zhdc_cx
		userdesc_104={-300},						--描述用：风蜈降闪避，对应wudu_zhdc_fw_skill		
		userdesc_105={6},							--描述用：墨蛛毒伤，对应wudu_zhdc_mz_skill		
		skill_statetime={{{1,2},{15,2},{16,2},{21,2}}},	
		skill_mintimepercast_v={{{1,35*15},{15,30*15},{16,30*15},{21,30*15}}},		
    },
	wudu_zhdc_ls = --召唤灵蛇
    { 
		call_npc1={2190, -1, 2},				--NPCid, NPC等级（-1为跟玩家一样），NPC五行
		remove_call_npc={2190},
		skill_statetime={{{1,15*15},{15,15*15},{16,15*15},{21,15*15}}},	

		userdesc_000={4313},
		userdesc_101={100,15*2},					--描述用：灵蛇造致缠，对应wudu_zhdc_ls_skill		
		userdesc_102={-300},						--描述用：碧蟾降木抗，对应wudu_zhdc_bc_skill		
		userdesc_103={{{1,5},{10,30},{11,33}}},		--描述用：赤蝎增加主角会心伤害,wudu_zhdc_cx
		userdesc_104={-300},						--描述用：风蜈降闪避，对应wudu_zhdc_fw_skill		
		userdesc_105={6},							--描述用：墨蛛毒伤，对应wudu_zhdc_mz_skill		

		addaction_event1={4312,4314},				--灵蛇被碧蟾替换	

		skill_mintimepercast_v={{{1,35*15},{15,30*15},{16,30*15},{21,30*15}}},		
    },	
	wudu_zhdc_ls_child = --召唤灵蛇_子
    { 
	 	callnpc_life={2190,{{1,150},{15,300},{16,320},{21,420}}},			--NPCid，生命值%
	 	callnpc_damage={2190,{{1,50},{15,100},{16,120},{21,220}}},			--NPCid，攻击力%
		skill_statetime={{{1,15*15},{15,15*15},{16,15*15},{21,15*15}}},		--持续时间需要跟召唤毒虫_灵蛇的时间一致
    },
	wudu_zhdc_bc = --召唤碧蟾
    { 
		call_npc1={2191, -1, 2},				--NPCid, NPC等级（-1为跟玩家一样），NPC五行
		remove_call_npc={2191},
		skill_statetime={{{1,15*15},{15,15*15},{16,15*15},{21,15*15}}},	

		userdesc_000={4313},
		userdesc_101={100,15*2},					--描述用：灵蛇造致缠，对应wudu_zhdc_ls_skill		
		userdesc_102={-300},						--描述用：碧蟾降木抗，对应wudu_zhdc_bc_skill		
		userdesc_103={{{1,5},{10,30},{11,33}}},		--描述用：赤蝎增加主角会心伤害,wudu_zhdc_cx
		userdesc_104={-300},						--描述用：风蜈降闪避，对应wudu_zhdc_fw_skill		
		userdesc_105={6},							--描述用：墨蛛毒伤，对应wudu_zhdc_mz_skill	

		addaction_event1={4312,4316},				--灵蛇被赤蝎替换	

		skill_mintimepercast_v={{{1,35*15},{15,30*15},{16,30*15},{21,30*15}}},		
    },	
	wudu_zhdc_bc_child = --召唤碧蟾_子
    { 
	 	callnpc_life={2191,{{1,150},{15,300},{16,320},{21,420}}},			--NPCid，生命值%
	 	callnpc_damage={2191,{{1,50},{15,100},{16,120},{21,220}}},			--NPCid，攻击力%
		skill_statetime={{{1,15*15},{15,15*15},{21,15*15}}},				--持续时间需要跟召唤毒虫_碧蟾的时间一致
    },
	wudu_zhdc_cx = --召唤赤蝎
    { 
		call_npc1={2192, -1, 2},				--NPCid, NPC等级（-1为跟玩家一样），NPC五行
		remove_call_npc={2192},
		deadlystrike_damage_p={{{1,5},{10,30},{11,33}}},
		skill_statetime={{{1,15*15},{15,15*15},{16,15*15},{21,15*15}}},

		userdesc_000={4313},
		userdesc_101={100,15*2},					--描述用：灵蛇造致缠，对应wudu_zhdc_ls_skill		
		userdesc_102={-300},						--描述用：碧蟾降木抗，对应wudu_zhdc_bc_skill
		userdesc_103={{{1,5},{10,30},{11,33}}},		--描述用：赤蝎增加主角会心伤害,wudu_zhdc_cx				
		userdesc_104={-300},						--描述用：风蜈降闪避，对应wudu_zhdc_fw_skill		
		userdesc_105={6},							--描述用：墨蛛毒伤，对应wudu_zhdc_mz_skill	

		addaction_event1={4312,4318},				--灵蛇被风蜈替换	

		skill_mintimepercast_v={{{1,35*15},{15,30*15},{16,30*15},{21,30*15}}},
    },	
	wudu_zhdc_cx_child = --召唤赤蝎_子
    { 
	 	callnpc_life={2192,{{1,150},{15,300},{16,320},{21,420}}},			--NPCid，生命值%
	 	callnpc_damage={2192,{{1,50},{15,100},{16,120},{21,220}}},			--NPCid，攻击力%
		skill_statetime={{{1,15*15},{15,15*15},{21,15*15}}},				--持续时间需要跟召唤毒虫_赤蝎的时间一致
    },
	wudu_zhdc_fw = --召唤风蜈
    { 
		call_npc1={2193, -1, 2},				--NPCid, NPC等级（-1为跟玩家一样），NPC五行
		remove_call_npc={2193},
		skill_statetime={{{1,15*15},{15,15*15},{16,15*15},{21,15*15}}},	

		userdesc_000={4313},
		userdesc_101={100,15*2},					--描述用：灵蛇造致缠，对应wudu_zhdc_ls_skill		
		userdesc_102={-300},						--描述用：碧蟾降木抗，对应wudu_zhdc_bc_skill		
		userdesc_103={{{1,5},{10,30},{11,33}}},		--描述用：赤蝎增加主角会心伤害,wudu_zhdc_cx
		userdesc_104={-300},						--描述用：风蜈降闪避，对应wudu_zhdc_fw_skill		
		userdesc_105={6},							--描述用：墨蛛毒伤，对应wudu_zhdc_mz_skill	

		--addaction_event1={4312,4320},				--灵蛇被墨蛛替换	

		skill_mintimepercast_v={{{1,35*15},{15,30*15},{16,30*15},{21,30*15}}},
    },	
	wudu_zhdc_fw_child = --召唤风蜈_子
    { 
	 	callnpc_life={2193,{{1,150},{15,300},{16,320},{21,420}}},			--NPCid，生命值%
	 	callnpc_damage={2193,{{1,50},{15,100},{16,120},{21,220}}},			--NPCid，攻击力%
		skill_statetime={{{1,15*15},{15,15*15},{21,15*15}}},				--持续时间需要跟召唤毒虫_风蜈的时间一致
    },
	wudu_zhdc_mz = --召唤墨蛛
    { 
		call_npc1={2194, -1, 2},				--NPCid, NPC等级（-1为跟玩家一样），NPC五行
		remove_call_npc={2194},
		skill_statetime={{{1,15*15},{15,15*15},{16,15*15},{21,15*15}}},

		userdesc_000={4313},
		userdesc_101={100,15*2},					--描述用：灵蛇造致缠，对应wudu_zhdc_ls_skill		
		userdesc_102={-300},						--描述用：碧蟾降木抗，对应wudu_zhdc_bc_skill		
		userdesc_103={{{1,5},{10,30},{11,33}}},		--描述用：赤蝎增加主角会心伤害,wudu_zhdc_cx
		userdesc_104={-300},						--描述用：风蜈降闪避，对应wudu_zhdc_fw_skill		
		userdesc_105={6},							--描述用：墨蛛毒伤，对应wudu_zhdc_mz_skill		

		skill_mintimepercast_v={{{1,35*15},{15,30*15},{16,30*15},{21,30*15}}},
    },	
	wudu_zhdc_mz_child = --召唤墨蛛_子
    { 
	 	callnpc_life={2194,{{1,150},{15,300},{16,320},{21,420}}},			--NPCid，生命值%
	 	callnpc_damage={2194,{{1,50},{15,100},{16,120},{21,220}}},			--NPCid，攻击力%
		skill_statetime={{{1,15*15},{15,15*15},{21,15*15}}},				--持续时间需要跟召唤毒虫_墨蛛的时间一致
    },
	wudu_zhdc_fuzhubuff = --召唤墨蛛替换用BUFF
    { 
		addaction_event1={4312,4320},				--灵蛇被墨蛛替换
		skill_statetime={{{1,15*15},{15,15*15},{16,15*15},{21,15*15}}},
    },
    wudu_zhdc_normal = --毒虫-普攻
    { 
		attack_usebasedamage_p={140},
		missile_hitcount={{{1,4},{15,4},{16,4}}},  
    },
    wudu_zhdc_ls_skill = --灵蛇技能（致残）
    { 
		attack_usebasedamage_p={280},
		state_zhican_attack={100,15*2},
    },
    wudu_zhdc_bc_skill = --碧蟾技能（降木抗）
    { 
		attack_usebasedamage_p={280},
		wood_resist_v={-300},
		skill_statetime={15*8},
    },
    wudu_zhdc_cx_skill = --赤蝎技能（增加会心伤害）
    { 
		deadlystrike_damage_p={50},		
    },
    wudu_zhdc_fw_skill = --风蜈技能（降闪避）
    { 
		attack_usebasedamage_p={280},
		defense_v={-300},
		skill_statetime={15*8},
    },
    wudu_zhdc_mz_skill = --墨蛛技能（毒伤）
    { 
		dotdamage_wood={{{1,1},{15,15},{16,16},{21,21}},{{1,10},{15,150},{16,160},{21,210}},15*0.5}, 	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		skill_dot_ext_type={1},	
		skill_statetime={15*2.5},
    },
	wudu_mxg = --迷心蛊-10级主动3--15级
    { 
		userdesc_000={4335,4336,4337},
		missile_hitcount={0,0,1},		
    },
	wudu_mxg_child1 = --迷心蛊_子1
    { 
		dotdamage_wood={{{1,1},{15,10},{16,11},{20,13},{21,14}},{{1,10},{15,150},{16,155},{20,180},{21,185}},15*0.5},  	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		skill_dot_ext_type={1},															--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		skill_statetime={{{1,15*7.5},{15,15*7.5},{16,15*7.5},{21,15*7.5}}},							--毒的持续时间
		userdesc_109={{{1,16},{15,16},{16,16},{21,16}}},										--描述用，显示毒的次数
		missile_hitcount={0,0,1},
    },
	wudu_mxg_child2 = --迷心蛊_子2
    { 
		recdot_wood_p={{{1,5},{15,30},{16,32},{20,36},{21,38}}},										--增加受到的毒伤%
		skill_statetime={{{1,15*7.5},{15,15*7.5},{16,15*7.5},{21,15*7.5}}},								--debuff的持续时间
    },
	wudu_mxg_child3 = --迷心蛊_子3
    { 
		state_zhican_attack={{{1,10},{15,25},{16,25},{21,25}},{{1,15*0.5},{15,15*0.5},{16,15*0.5},{21,15*0.5}}},
		skill_ignore_npchurt = {1},				--标记野怪不被此技能打到后仰效果
		missile_hitcount={0,0,1},
    },
    wudu_yds = --驭毒术-20级被动1--10级
    { 
		physics_potentialdamage_p={{{1,15},{10,40},{11,50},{15,60},{16,64}}},
		add_dotdshield_p={2,{{1,10},{10,40},{11,45},{15,60},{16,64},{17,66}}},			--毒攻dot对护盾的伤害提高：五行类型，百分比
		state_stun_resistrate={{{1,15},{10,150},{11,165}}},
		skill_statetime={{{1,-1},{10,-1},{11,-1}}},
    },
    wudu_wgsx = --万蛊蚀心-30级主动4--15级
    { 
		attack_usebasedamage_p={{{1,260},{15,350},{16,360},{20,380},{21,400}}},
		attack_wooddamage_v={
			[1]={{1,600*1},{15,1000*1},{16,1300*1},{20,1500*1},{21,1600*1}},
			[3]={{1,600*1},{15,1000*1},{16,1300*1},{20,1500*1},{21,1600*1}}
			},
		--dotdamage_wood={{{1,1},{15,15},{16,16}},{{1,10},{15,150},{16,160}},15*0.5},  	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔
		--skill_statetime={{{1,15*0.1},{15,15*0.1},{16,15*0.1}}},							--毒的持续时间
		--skill_dot_ext_type={1},															--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		state_zhican_attack={{{1,60},{15,90},{16,95},{21,95}},{{1,15*1.5},{15,15*1.5},{16,15*1.5},{21,15*1.5}}},
		state_npchurt_attack={100,7},
		userdesc_000={4340},
		missile_hitcount={{{1,5},{15,5},{16,5},{21,5}}},
		skill_mintimepercast_v={{{1,45*15},{15,40*15},{16,40*15},{21,40*15}}},	
    },
    wudu_wgsx_child = --万蛊蚀心_子
    { 
		receive_dot_alldmg={{{1,40},{15,70},{16,70},{21,75}},3,{{1,50},{15,100},{16,100},{21,100}}},				--引爆的伤害比例，技能类型索引SkillSetting.ini，引爆的次数比例
		missile_hitcount={{{1,5},{15,5},{16,5},{21,5}}},
    },
    wudu_bdcx = --百毒穿心-40级被动2--10级
    { 
		deadlystrike_p={{{1,60},{10,120},{11,132}}},
		userdesc_000={4342},		
		autoskill={119,{{1,1},{10,10},{11,11}}},
		userdesc_101={{{1,15*6},{10,15*3},{11,15*3}}},
		skill_statetime={{{1,-1},{10,-1},{11,-1}}},
    },	
    wudu_bdcx_child = --百毒穿心_减毒虫CD--10级
    { 
		reduce_cd_time_point1={4312,{{1,15*7},{15,15*14},{17,15*15}}},			--减少冷却时间
		skill_statetime={{{1,2},{10,2},{11,2}}},
    },	
    wudu_gjdz = --高级笛咒-50级被动3--10级
    {
		add_skill_level={4301,{{1,1},{10,10},{11,11}},0},
		add_skill_level2={4302,{{1,1},{10,10},{11,11}},0},
		add_skill_level3={4303,{{1,1},{10,10},{11,11}},0},
		add_skill_level4={4304,{{1,1},{10,10},{11,11}},0},	
		userdesc_000={4344},
		skill_statetime={{{1,-1},{10,-1},{11,-1}}},
    },
    wudu_gjdz_child = --高级笛咒_子（仅用作显示，无实际效果加成。实际效果查看普攻的21-30级）--10级
    { 
		userdesc_101={{{1,2},{10,20},{11,25}},{{1,7},{10,70},{11,80}},15*0.5}, 		--毒伤：发挥基础攻击力，毒攻点数，伤害间隔 
		--skill_statetime={{{1,15*3.5},{15,15*3.5},{16,15*3.5}}},					--毒的持续时间
		--userdesc_109={{{1,8},{15,8},{16,8}}},										--描述用，显示毒的次数
		skill_dot_ext_type={1},														--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
    }, 
    wudu_wxg = --无形蛊-60级被动4--10级
    { 
		autoskill={120,{{1,1},{10,10},{11,11}}},
		userdesc_000={4346},
		userdesc_101={{{1,50},{10,70},{11,75}}},		--描述用，实际触发几率请查看autoskill.tab中的无形蛊
		userdesc_102={{{1,15*5},{10,15*5},{11,15*5}}},	--描述用，实际触发间隔请查看autoskill.tab中的无形蛊	
		skill_statetime={{{1,-1},{10,-1},{11,-1}}},
    },
    wudu_wxg_child = --无形蛊_子
    {
		--attack_usebasedamage_p={{{1,50},{10,80},{11,83}}},
		--attack_metaldamage_v={
		--	[1]={{1,100*1},{10,240*0.95},{11,254*0.95}},
		--	[3]={{1,100*1},{10,240*1.05},{11,254*1.05}}
		--	},
		dotdamage_wood={{{1,10},{10,20},{11,22}},{{1,100},{10,200},{11,220}},15*0.5}, 	--毒伤：发挥基础攻击力，毒攻点数，伤害间隔 
		skill_statetime={{{1,15*10},{15,15*10},{16,15*10}}},						--毒的持续时间
		userdesc_109={{{1,22},{15,22},{16,22}}},										--描述用，显示毒的次数
		skill_dot_ext_type={1},														--增加受到的毒伤%的标记，有dotdamage_wood的技能都要加上
		missile_hitcount={1,1,1},		
    },
    wudu_hhmz = --回魂秘咒-70级被动5--10级
    {
		autoskill={121,{{1,1},{10,10},{11,11}}},
		userdesc_000={4348},
		userdesc_101={{{1,40},{10,90},{11,95}}},			--描述用，实际触发几率请查看autoskill.tab中的回魂秘咒
		userdesc_102={{{1,15*30},{10,15*30},{11,15*30}}},	--描述用，实际触发间隔请查看autoskill.tab中的回魂秘咒
		skill_statetime={{{1,-1},{10,-1},{11,-1}}},
    },
    wudu_hhmz_child1  = --回魂秘咒_子
    {
		stealdmg_shield={{{1,5},{10,25},{11,30}}},		--护盾吸收伤害的%转换成生命回复
		certainly_hit={},								--必然被击中
		skill_statetime={{{1,15*2},{10,15*4},{11,15*4}}},
    },
    wudu_hhmz_child2  = --回魂秘咒_清除控制
    {
		ignore_series_state={},		--免疫属性效果
		ignore_abnor_state={},		--免疫负面效果
		skill_statetime={{{1,3},{10,3},{11,3}}},
    },
    wudu_wdxf = --万毒心法-80级被动6--20级
    {
		physics_potentialdamage_p={{{1,3},{20,45},{24,45*1.2}}},
		lifemax_p={{{1,4},{20,80},{24,80*1.2}}},
		attackspeed_v={{{1,5},{20,20},{24,20*1.2}}},
		all_series_resist_p={{{1,3},{20,55},{24,55*1.2}}},
		state_zhican_attackrate={{{1,10},{20,200},{24,200*1.2}}},
		state_stun_resisttime={{{1,10},{20,200},{24,200*1.2}}},
		skill_statetime={-1},
    },
    wudu_wdqj = --五毒奇经-90级被动7--10级
    { 
		autoskill={122,{{1,1},{10,10},{11,11}}},		
		userdesc_000={4351},
		userdesc_101={{{1,2},{10,20},{11,22}}},					--描述用，实际触发几率请查看autoskill.tab中的五毒奇经	
		userdesc_102={{{1,15*5},{10,15*5},{15,15*5}}},			--描述用，实际触发间隔请查看autoskill.tab中的五毒奇经	
		skill_statetime={{{1,-1},{10,-1},{11,-1}}},	
    },
    wudu_wdqj_child = --五毒奇经_子
    { 
		infect_dot_dmg={
			{{1,5},{10,30},{11,35},{15,45},{16,48}},
			3,
			{{1,1},{4,1},{5,2},{9,2},{10,3},{11,4},{12,4}}},		--传递的伤害比例，能被传染的类型SkillSetting.ini,数量
		skill_infectdot_info={400,4352,{{1,1},{10,10},{11,11}}},							--传染的直径，传染触发的技能，传染触发的技能等级
		missile_hitcount={1,1,1},		
    },
    wudu_wgtxz = --万蛊天仙照
    { 
		userdesc_000={4357},	
    },
    wudu_wgtxz_child1 = --万蛊天仙照_伤害
    { 
		attack_usebasedamage_p={{{1,800},{30,800}}},
		attack_wooddamage_v={
			[1]={{1,2000*0.9},{30,2000*0.9},{31,2000*0.9}},
			[3]={{1,2000*1.1},{30,2000*1.1},{31,2000*1.1}}
			},		
    },
    wudu_wgtxz_child2 = --万蛊天仙照_免疫
    { 
		ignore_series_state={},		--免疫属性效果
		ignore_abnor_state={},		--免疫负面效果
		skill_statetime={{{1,20},{30,20}}},
    },	
}

FightSkill:AddMagicData(tb)