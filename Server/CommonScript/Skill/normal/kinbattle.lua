
local tb    = {
	kinbattle_change_nuche= 	--变身弩车（家族战）
    { 
		shapeshift={3193,2},								--npcid
		lifemax_v={{{1,480000},{2,720000},{3,960000},{4,1200000},{5,1440000},{6,1800000},{7,2160000},{8,2400000}}},	
		all_series_resist_v={{{1,1050},{2,1250},{3,1450},{4,1650},{5,1850},{6,2050},{7,2250},{8,2450}}},
		attackrate_v={{{1,5000},{2,6000},{3,7000},{4,7800},{5,8800},{6,9800},{7,11000},{8,15000}}},
		defense_v={{{1,1500},{2,1800},{3,2000},{4,2200},{5,2400},{6,2600},{7,2800},{8,3000}}},
		deadlystrike_v={{{1,400},{2,450},{3,500},{4,550},{5,600},{6,650},{7,700},{8,800}}},
		add_skill_level={5145,{{1,0},{10,9},{11,9}},0},							--变身时同时给普攻增加几级
		add_skill_level2={5147,{{1,0},{10,9},{11,9}},0},						--变身时同时给特殊技能增加几级
		ignore_series_state={},	
		ignore_abnor_state={},	
		enhance_final_damage_p={{{1,5},{2,10},{3,15},{4,20},{5,25},{6,30},{7,35},{8,40}}},
		reduce_final_damage_p={{{1,5},{2,10},{3,15},{4,20},{5,25},{6,30},{7,35},{8,40}}},
		steallife_resist_p={{{1,100},{8,100}}},
		skill_statetime={{{1,15*20},{30,15*20}}},
    },
	kinbattle_sqgz=
    { 
		lifemax_p={{{1,20},{10,100}}},
		physics_potentialdamage_p={{{1,20},{10,40}}},
		skill_statetime={{{1,15*20},{30,15*20}}},
    },
    kinbattle_jingnuche_normal= --劲弩车普攻
    { 
		attack_holydamage_v={
			[1]={{1,2000},{2,4000},{3,6000},{4,8000},{5,10000},{6,12000},{7,14000},{8,16000},{9,18000}},
			[3]={{1,2000},{2,4000},{3,6000},{4,8000},{5,10000},{6,12000},{7,14000},{8,16000},{9,18000}}
			},
		missile_hitcount={5,0,0},
    }, 	
    kinbattle_jingnuche_shanxing= --劲弩车扇形弩
    { 
		attack_holydamage_v={
			[1]={{1,10000},{2,20000},{3,30000},{4,40000},{5,50000},{6,60000},{7,70000},{8,80000},{9,90000}},
			[3]={{1,10000},{2,20000},{3,30000},{4,40000},{5,50000},{6,60000},{7,70000},{8,80000},{9,90000}}
			},
		missile_hitcount={5,0,0},
    }, 
}

FightSkill:AddMagicData(tb)