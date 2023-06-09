
local tb    = {
    th_pg1 = {--桃花箭术1-普攻1式--20级
		attack_attackrate_v={100},
		attack_usebasedamage_p={{{1,60},{20,90},{30,120},{31,123}}},
		attack_firedamage_v={
			[1]={{1,60*2*0.9},{20,90*2*0.9},{30,120*2*0.9},{31,123*2*0.9}},
			[3]={{1,60*2*1.1},{20,90*2*1.1},{30,120*2*1.1},{31,123*2*1.1}}
			},
		state_npchurt_attack={100,7},
		missile_hitcount={4,0,0},
    },
    th_pg2 = {--桃花箭术2-普攻2式--20级
		attack_attackrate_v={100},
		attack_usebasedamage_p={{{1,60},{20,90},{30,120},{31,123}}},
		attack_firedamage_v={
			[1]={{1,60*2*0.9},{20,90*2*0.9},{30,120*2*0.9},{31,123*2*0.9}},
			[3]={{1,60*2*1.1},{20,90*2*1.1},{30,120*2*1.1},{31,123*2*1.1}}
			},
		state_npchurt_attack={100,7},
		missile_hitcount={4,0,0},
    },
    th_pg3 = {--桃花箭术3-普攻3式--20级
		attack_attackrate_v={100},
		attack_usebasedamage_p={{{1,60},{20,90},{30,120},{31,123}}},
		attack_firedamage_v={
			[1]={{1,60*2*0.9},{20,90*2*0.9},{30,120*2*0.9},{31,123*2*0.9}},
			[3]={{1,60*2*1.1},{20,90*2*1.1},{30,120*2*1.1},{31,123*2*1.1}}
			},
		state_npchurt_attack={100,7},
		missile_hitcount={4,0,0},
    },
    th_pg4 = {--桃花箭术4-普攻4式--20级
		attack_attackrate_v={100},
		attack_usebasedamage_p={{{1,60*1.5},{20,90*1.5},{30,120*1.5},{31,123*1.5}}},
		attack_firedamage_v={
			[1]={{1,60*1.5*2*0.9},{20,90*1.5*2*0.9},{30,120*1.5*2*0.9},{31,123*1.5*2*0.9}},
			[3]={{1,60*1.5*2*1.1},{20,90*1.5*2*1.1},{30,120*1.5*2*1.1},{31,123*1.5*2*1.1}}
			},
		state_npchurt_attack={100,7},
		state_palsy_attack={80,8},
		missile_hitcount={4,0,0},
    },

    th_fhlx = {--飞火流星-1级主动1 --10级
		adddamagebydist={1,150000,100},					--放大%=(min(（距离-参数3）*参数1，参数2)/1000)%
		attack_usebasedamage_p={{{1,253},{15,391},{20,441}}},
		attack_firedamage_v={
			[1]={{1,253*2*0.9},{15,391*2*0.9},{20,441*2*0.9}},
			[3]={{1,253*2*1.1},{15,391*2*1.1},{20,441*2*1.1}}
		},
		state_palsy_attack={{{1,50},{15,100},{16,100},{21,100}},{{1,15*1.5},{15,15*1.5},{16,15*1.5},{21,15*1.5}}},

		skill_mintimepercast_v={7.5*15},
		
		missile_hitcount={4,0,0},
    },
    th_fhlx_child1 = {--飞火流星驱散
		missile_hitcount={4,0,0},
    },
    th_fhlx_child2 = {--飞火流星击退
		state_knock_attack={100,12,80},
		state_npcknock_attack={100,12,80},
		spe_knock_param={9 , 4, 9},			--停留时间，玩家动作ID，NPC动作ID
		skill_knock_len={1,480,0},			--是否击退到朝向垂线的投影点,击退距离,相对npc还是子弹
		
		missile_hitcount={4,0,0},
    },

	th_book1 = {--飞火流星秘籍
		add_hitskill1={464,418,{{1,1},{10,10},{20,20}}},

		add_usebasedmg_p1={407,{{1,0},{10,0},{11,10},{15,49},{20,49}}},
		--deccdtime={407,{{1,0},{10,0},{11,0.5*15},{15,2.5*15},{20,2.5*15}}},

		add_adddmgbydist={407,{{1,0},{15,0},{16,16},{20,80}}},

		skill_statetime={-1},

		userdesc_000={418},
    },
    th_book1_child1 = {--初级飞火流星秘籍
		rand_ignoreskill={{{1,50},{10,100},{20,100}},1,1},		--概率，数量，类型（skillsetting下定义类型）
		state_burn_attack={{{1,30},{10,100},{20,100}},5*15,30},
		missile_hitcount={0,0,1},
    },

    th_jylz = {--九曜连珠-4级主动2--10级
		attack_usebasedamage_p={{{1,237/1.2},{15,487/1.2},{20,577/1.2}}},
		attack_firedamage_v={
			[1]={{1,237/1.2*2*0.9},{15,487/1.2*2*0.9},{20,577/1.2*2*0.9}},
			[3]={{1,237/1.2*2*1.1},{15,487/1.2*2*1.1},{20,577/1.2*2*1.1}}
		},
		state_palsy_attack={{{1,40},{15,80},{20,80}},1.5*15},
		state_fixed_attack={0,0},  --秘籍需要用到
		state_npchurt_attack={100,9},
		
		missile_hitcount={4,0,0},

		skill_mintimepercast_v={12*15},
		
		--持续伤害描述
		userdesc_101={{{1,237/30},{15,487/30},{20,577/30}}},
		userdesc_102={
			[1]={{1,237/30*2*0.9},{15,487/30*2*0.9},{20,577/30*2*0.9}},
			[3]={{1,237/30*2*1.1},{15,487/30*2*1.1},{20,577/30*2*1.1}}
		},
		userdesc_103={{{1,10},{15,10},{16,10},{21,10}},{{1,15*0.5},{15,15*0.5},{16,15*0.5},{21,15*0.5}}},
    },
    th_jylz_child = {--九曜连珠-10级主动3--10级
		attack_usebasedamage_p={{{1,237/30},{15,487/30},{20,577/30}}},
		attack_firedamage_v={
			[1]={{1,237/30*2*0.9},{15,487/30*2*0.9},{20,577/30*2*0.9}},
			[3]={{1,237/30*2*1.1},{15,487/30*2*1.1},{20,577/30*2*1.1}}
		},
		state_palsy_attack={{{1,10},{15,10},{16,10},{21,10}},{{1,15*0.5},{15,15*0.5},{16,15*0.5},{21,15*0.5}}},
		state_npchurt_attack={100,9},

		ms_one_hit_count = {4,0,0},				--每次攻击最大数量
    },

	th_book2 = { --九曜连珠秘籍,
		add_fixed_r={410,{{1,5},{10,50},{20,50}}},		--增加造成定身的概率
		add_fixed_t={410,15},							--增加造成定身的时间

		autoskill={167,{{1,0},{10,0},{11,11},{15,15},{20,20}}},				--普攻概率刷新cd

		add_usebasedmg_p1={411,{{1,0},{15,0},{16,3},{20,18}}},				--增加九曜连珠持续伤害
		skill_statetime={-1},
		
		userdesc_101={{{1,0},{10,0},{11,1},{15,5},{20,5}}},
	},
	th_book2_child2 = { --九曜连珠秘籍
		reduce_cd_time1={410,12*15},
	},

    th_hfly = {--火凤燎原-10级主动3--15级
		ignore_all_resist={100,{{1,3},{15,45},{20,60}}},
		attackspeed_v={{{1,20},{15,50},{16,52},{21,62}}},
		runspeed_v={{{1,100},{15,200},{16,210},{21,260}}},
		defense_p={{{1,50},{15,130},{20,173},{21,182}}},

		skill_statetime={10*15},

		skill_mintimepercast_v={30*15},
    },

	th_book3 = {  --火凤燎原秘籍
		addstartskill={406,414,{{1,1},{10,10},{20,20}}},
		
		add_state_time1={406,{{1,0},{10,0},{11,1.2*15},{15,6*15},{20,6*15}}},  			--增加火凤燎原持续时间
		
		addstartskill2={414,{{1,0},{15,0},{16,459},{20,459}},{{1,0},{15,0},{16,16},{20,20}}},
		
		skill_statetime={-1},
		
		userdesc_000={459,414},
	},
	th_book3_child1 = {--初级火凤燎原秘籍
		ignore_abnor_state={},
		state_hurt_ignore={1},
		skill_statetime={{{1,1*15},{10,10*15},{11,11.2*15},{15,16*15},{20,16*15}}},
    },
	th_book3_child3 = {--高级火凤燎原
		defense_p={{{1,0},{15,0},{16,26},{20,130}}},
		skill_statetime={{{1,0},{15,0},{16,16*15},{20,16*15}}},
    },

    th_lfhx = {--流风回雪-20级被动1--10级
	--	runspeed_v={{{1,10},{30,50}}},
		physics_potentialdamage_p={{{1,20},{10,50},{11,55}}},
		defense_p={{{1,3},{10,30},{11,33}}},
		state_hurt_resistrate={{{1,15},{10,150},{11,165}}},
		skill_statetime={{{1,-1},{10,-1}}},
    },
	
    th_cypy = {--穿云破月-30级主动4--15级
		attack_usebasedamage_p={{{1,349},{15,725},{20,859}}},
		attack_firedamage_v={
			[1]={{1,349*2*0.9},{15,725*2*0.9},{20,859*2*0.9}},
			[3]={{1,349*2*1.1},{15,725*2*1.1},{20,859*2*1.1}}
		},
	--	state_palsy_attack={{{1,100},{30,100},{31,100}},{{1,15*1},{30,15*1}}},

	--	state_knock_attack={30,12,30},
		state_npcknock_attack={100,12,30},
		spe_knock_param={9 , 4, 26},
		missile_hitcount={4,0,0},
		
		skill_mintimepercast_v={30*15},
    },
	th_cypy_child = {--穿云破月_触发减cd用
		missile_hitcount={0,0,6},
    },
	
    th_book4 = {--高级穿云破月
		add_usebasedmg_p1={412,{{1,13},{10,135},{20,135}}},			--增加穿云破月攻击力
		
		deccdtime={412,{{1,0},{10,0},{11,1.2*15},{15,6*15},{20,6*15}}},		--减穿云破月CD时间
		
		add_hitskill1={438,{{1,0},{15,0},{16,461},{20,461}},{{1,0},{15,0},{16,16},{20,20}}},
		
		skill_statetime={-1},
		
		userdesc_000={461,438},
    },
    th_book4_child3 = {--高级穿云破月_减少自身技能cd		
		reduce_cd_time1={406,{{1,0},{15,0},{16,0.5*15},{20,2.5*15}}},			--火凤燎原
		reduce_cd_time2={410,{{1,0},{15,0},{16,0.5*15},{20,2.5*15}}},			--九曜连珠
		--减穿云破月CD时间,reduce_cd_time_point1不会触发deccdtime
		reduce_cd_time_point1={412,{{1,0},{15,0},{16,0.5*15},{20,2.5*15}}},		--穿云破月
		reduce_cd_time4={407,{{1,0},{15,0},{16,0.5*15},{20,2.5*15}}},			--飞火流星
		skill_statetime={1},
    },
	
    th_nzjy = {--逆转九阴-40级被动2--10级
		melee_dmg_p={{{1,-1},{10,-15},{12,-18}}},
		autoskill={42,{{1,1},{10,10},{11,11}}},
		skill_statetime={-1},

		userdesc_000={444},
		userdesc_101={{{1,15*20},{10,10*15},{11,10*15}}},		--仅为描述，真实概率与时间于autoskill.tab中设置
    },
    th_nzjy_child = {--逆转九阴_子-40级被动2--10级
		state_knock_attack={100,3,80},
		state_npcknock_attack={100,3,80},
		spe_knock_param={0 , 9, 9},
		
		--allfactionskill_cd={{{1,1*15},{10,2*15},{11,2*15}}},						--增加敌人主动技能CD时间
		physics_potentialdamage_p={{{1,-17},{10,-170},{12,-170*1.2}}},
		skill_statetime={3*15},				--debuff的持续时间
		
		missile_hitcount={4,0,0},
    },
	
    th_gjjs = {--百步穿杨-50级被动3--10级
		addaction_event1={404,421},		--技能404被421替换
		add_skill_level={401,{{1,1},{10,10},{11,11}},0},
		add_skill_level2={402,{{1,1},{10,10},{11,11}},0},
		add_skill_level3={403,{{1,1},{10,10},{11,11}},0},
		add_skill_level4={404,{{1,1},{10,10},{11,11}},0},
		userdesc_000={439},
		skill_statetime={{{1,-1},{20,-1}}},
    },
    th_gjjs_child1 = {--百步穿杨_伤害--10级
		attack_attackrate_v={100},
		attack_usebasedamage_p={{{1,60*1.5},{20,90*1.5},{30,120*1.5},{31,123*1.5}}},
		attack_firedamage_v={
			[1]={{1,60*1.5*2*0.9},{20,90*1.5*2*0.9},{30,120*1.5*2*0.9},{31,123*1.5*2*0.9}},
			[3]={{1,60*1.5*2*1.1},{20,90*1.5*2*1.1},{30,120*1.5*2*1.1},{31,123*1.5*2*1.1}}
		},
		state_npchurt_attack={100,7},
		state_palsy_attack={80,8},
		missile_hitcount={4,0,0},
    },
    th_gjjs_child2 = {--百步穿杨_子2（仅用作显示，无实际效果加成。实际效果查看普攻的21-30级）--10级
		attack_usebasedamage_p={{{1,3},{10,30},{12,36}}},
		attack_firedamage_v={
			[1]={{1,3*2*0.9},{10,30*2*0.9},{12,36*2*0.9}},
			[3]={{1,3*2*1.1},{10,30*2*1.1},{12,36*2*1.1}}
		},
    },
    th_qyby = {--轻云蔽月--60级被动4--10级
		autoskill={168,{{1,1},{10,10},{11,11}}},
		skill_statetime={-1},
		
		userdesc_000={466},
    },
    th_qyby_child = {--轻云蔽月--60级被动4--10级
		add_usebasedmg_p1={401,{{1,6},{10,60},{11,69}}},
		add_usebasedmg_p2={402,{{1,6},{10,60},{11,69}}},
		add_usebasedmg_p3={403,{{1,6},{10,60},{11,69}}},
		add_usebasedmg_p4={421,{{1,6*1.5},{10,60*1.5},{11,69*1.5}}},
		add_ignore_invin1={401,1},
		add_ignore_invin2={402,1},
		add_ignore_invin3={403,1},
		add_ignore_invin4={421,1},
		
		attackspeed_v={{{1,2},{10,20},{11,20}}},
		skill_statetime={3*15},
    },
    th_yhcs = {--浴火重生-70级被动5--10级
		autoskill={41,{{1,1},{10,10},{11,11}}},
		userdesc_000={426},
		userdesc_101={{{1,40},{10,90},{11,95}}},			--描述用，实际触发几率请查看autoskill.tab中的浴火重生
		userdesc_102={{{1,15*30},{10,15*30},{11,15*30}}},		--描述用，实际触发几率请查看autoskill.tab中的浴火重生
		skill_statetime={-1},
    },
    th_yhcs_child = {--浴火重生_子--10级
	 	recover_life_p={{{1,1},{10,4},{11,4}},15},
		--autoskill2={43,{{1,1},{10,10},{11,11}}},		--此处触发等级不生效。取的是“火凤燎原”的当前等级
		skill_statetime={{{1,15*2},{10,15*3},{11,15*3}}},
    },
    th_fync = {--凤羽霓裳-80级被动6--20级
		physics_potentialdamage_p={{{1,2},{20,35},{24,35*1.2}}},
		lifemax_p={{{1,4},{20,80},{24,80*1.2}}},
		attackspeed_v={{{1,5},{20,20},{24,20*1.2}}},
		defense_p={{{1,3},{20,45},{24,45*1.2}}},
		state_palsy_attackrate={{{1,10},{20,200},{24,200*1.2}}},
		state_hurt_resisttime={{{1,10},{20,200},{24,200*1.2}}},
		skill_statetime={-1},
    },
	th_90_ylxc = {--月落星沉-90级被动7--10级
		autoskill={44,{{1,1},{10,10},{11,11}}},
		skill_statetime={-1},
		
		userdesc_102={{{1,5},{10,10},{11,10}}},				--描述用，触发几率。实际几率查看autoskill.tab的月落星沉
		userdesc_000={463},
    },
	th_90_ylxc_child = {--月落星沉
		damage_maxlife_p={{{1,3},{10,10},{11,11}},150},
		ms_one_hit_count = {0,0,1},
    },
	
    th_lhfxy = {--落花焚星焱-怒气
		--autoskill={41,{{1,1},{30,10},{31,10}}},
		--skill_statetime={{{1,-1},{30,-1}}},
    },
    th_lhfxy_child1 = {--落花焚星焱_子1
		--ms_randres_id1={25,427},
		--ms_randres_id2={100,428},
		--ms_randres_id3={25,429},
		--ms_randres_id4={25,430},
		attack_usebasedamage_p={{{1,800},{30,800}}},
		attack_firedamage_v={
			[1]={{1,200*0.9},{30,200*0.9},{31,200*0.9}},
			[3]={{1,200*1.1},{30,200*1.1},{31,200*1.1}}
		},
    },
    th_lhfxy_child2 = {--落花焚星焱_子2
		ignore_series_state={},		--免疫属性效果
		ignore_abnor_state={},		--免疫负面效果
		skill_statetime={{{1,37},{30,37}}},
    },
}

FightSkill:AddMagicData(tb)