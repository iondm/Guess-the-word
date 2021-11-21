import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:sofia/models/level.dart';
import 'package:sofia/models/word.dart';

class Constants {
  Constants._();

  static var levels = [
    new Level.data(
      id: "start_v1",
      name: "start",
      type: "offline",
      imagePath: "assets/images/start.png",
    ),
    new Level.data(
      id: "sport_v1",
      name: "sport",
      type: "offline",
      imagePath: "assets/images/sports.png",
    ),
    new Level.data(
      id: "monument_v1",
      name: "monument",
      type: "offline",
      imagePath: "assets/images/monument.png",
    ),
    new Level.data(
      id: "animal_v1",
      name: "animal",
      type: "offline",
      imagePath: "assets/images/turtle.png",
    ),
    new Level.data(
      id: "vehicle_v1",
      name: "vehicle",
      type: "offline",
      imagePath: "assets/images/vehicle.png",
    )
  ];

  static final vehicle_v1 = [
    new Word.data(
      synsetId: 'bn:00007309n',
      levelId: 'vehicle_v1',
      lemma: 'car',
      lemmas:
          'null;automobile;car;motorcar;auto;machine;motor_car;🚗;m1_vehicle;ottomobile;automobles;motor_carriage;environmental_impact_of_cars;automobil;automobilism;🚘;motor-car;automobiles;self-propelling_carriage;autos;self-rolling_carriage;the_automobile;cars;environmental_impact_of_automobiles;car_automobile;passenger_vehicles;passenger_vehicle;autocar',
    ),
    new Word.data(
      synsetId: 'bn:00077857n',
      levelId: 'vehicle_v1',
      lemma: 'tractor',
      lemmas:
          'null;tractor;row_crop_tractors;compact_utility_tractor;row_crop_tractor;agricultural_vehicles;rowcrop;tractors;🚜;agrotractor;tractor_model;row_crop;row-crop_tractor;steam_negro;tractor_war;agricultural_tractors;classic_tractor;tractor_wars;row-crop;nebraska_tractor_test;great_tractor_war;great_tractor_wars;agricultural_tractor;farm_tractor;tractor_safety',
    ),
    new Word.data(
      synsetId: 'bn:00002275n',
      levelId: 'vehicle_v1',
      lemma: 'aircraft',
      lemmas:
          'null;aircraft;aerial_vehicle;aeroplane;airplane;aircraf;heavier_than_air;heavier-than-air;aicraft;aircrafts;heavier-than-air_aircraft;individual_aircraft;heavier_than_air_flight;aircafts;aerodyne;heavier-than-air_flight;heavier_than_air_aircraft;air_industry;engine_packs;air_craft',
    ),
    new Word.data(
      synsetId: 'bn:00007329n',
      levelId: 'vehicle_v1',
      lemma: 'bus',
      lemmas:
          'null;bus;autobus;motorbus;coach;omnibus;jitney;motorcoach;passenger_vehicle;charabanc;double-decker;motor_bus;bus_transport;charter_bus;motor_coach;busses;busloads;busing;bus_loads;bused;neighborhood_bus;public_service_vehicle;bus_operator;motor_omnibus;express_coach;bus_door;bus_trip;triple_decker_bus;bikes-on-board;back_of_the_bus;motorbuses;hoverbus;bussed;the_bus;buses;bus-loads;bus_routes;bus-load;bus_lines;bus_carrier;coach_charter;bus_load;bus_route;bus_preservation;bussing;multibus;euro_bus_expo;🚍;bus_exposition;autobuses;cybermove;omnibus_line;🚌;bus_transportation;motor_buses',
    ),
    new Word.data(
      synsetId: 'bn:00066028n',
      levelId: 'vehicle_v1',
      lemma: 'train',
      lemmas:
          'null;train;railroad_train;passenger_trains;rail_train;railway_train;passenger_train;guided_train;international_train;trainset;railtrain;trainsets;rail-train;trains;passenger_railroad;consist;rail_vehicles;passenger_services;chooch;local_trains;rake',
    ),
  ];

  static final sport_v1 = [
    new Word.data(
      synsetId: 'bn:00023320n',
      levelId: 'sport_v1',
      lemma: 'Tennis',
      lemmas: 'real_tennis;court_tennis;royal_tennis;real_tennis_rules;tennis',
    ),
    new Word.data(
      synsetId: 'bn:00080220n',
      levelId: 'sport_v1',
      lemma: 'Volleyball',
      lemmas:
          'volleyball;volley_ball;volleyball_game;volley-ball;serve;opposite_hitter;setter;indoor_volleyball;lebro;women\'s_volleyball;opposite;court;rally_point_system;volleyball_dig;volleyball_rules;vollyball;🏐;v-ball;mintonette;outside_hitter;libero;volleyball_positions;history_of_volleyball;high_school_volleyball',
    ),
    new Word.data(
      synsetId: 'bn:00068511n',
      levelId: 'sport_v1',
      lemma: 'Rugby',
      lemmas:
          'rugby_football;rugby;rugger;rugby_club;rugby_footballer;girls_rugby;🏉;game_rugby;rugby_codes;egg_chasing;history_of_rugby_football',
    ),
    new Word.data(
      synsetId: 'bn:00041010n',
      levelId: 'sport_v1',
      lemma: 'Golf',
      lemmas:
          'golf;golf_game;golf_tournament;golf_conditioning;the_development_of_golf_technology;scotch_foursomes;🏌️‍♂️;🏌;golf_technology;scramble;texas_scramble;🏌️;ball_golf;men\'s_golf',
    ),
    new Word.data(
      synsetId: 'bn:00044331n',
      levelId: 'sport_v1',
      lemma: 'Ice_hockey',
      lemmas:
          'ice_hockey;hockey;hockey_game;women\'s_ice_hockey;ice_hockey_players;goaltender_coach;hocky;ishockey;canadian_hockey;hockey_with_puck;history_of_ice_hockey;ice-hockey;🏒;hawkie;icehockey;ice_hocky;eishockey;ice-hocky;girls_ice_hockey;ice_polo;position',
    ),
    new Word.data(
      synsetId: 'bn:00049631n',
      levelId: 'sport_v1',
      lemma: 'Lacrosse',
      lemmas:
          'lacrosse;lacrosse_players;indians_created_lacrosse;lacross;🥍;baggatiway;baggataway',
    ),
  ];

  static final animal_v1 = [
    new Word.data(
      synsetId: 'bn:00036129n',
      levelId: 'animal_v1',
      lemma: 'fox',
      lemmas:
          'fox;vocalizations_of_foxes;sex_organs_of_foxes;fox_habitat;foxes;sexual_characteristics_of_foxes;behavior_of_foxes;focks;fox_attack;foxs;🦊;fox_teeth;fox_penis;river_fox;todde;genitalia_of_foxes',
    ),
    new Word.data(
      synsetId: 'bn:00059723n',
      levelId: 'animal_v1',
      lemma: 'otter',
      lemmas:
          'otter;lutrinae;the_otter_subfamily;🦦;otters;otters_in_popular_culture;lutrine;otter_hunting;satherium;otters_in_japanese_folklore;holt;otters_in_religion_and_mythology',
    ),
    new Word.data(
      synsetId: 'bn:00021704n',
      levelId: 'animal_v1',
      lemma: 'rabbit',
      lemmas:
          'rabbit;coney;cony;rabbit_meat;bunnies;rubbits;rabbits;🐰;rabbitology;rabbits_in_folklore;thermoregulation_in_rabbits;cecal_pellets;rabbits_and_hares;bunny_rabbits;rabbitkind;smeerp;bunny_rabbit;feral_rabbits;bunny;bunnies!;rabbits_in_mythology;wild_rabbits;bunneh;rabbit_as_food;bunnie;🐇;bunnys;sex_organs_of_rabbits;a_rabbit;bunnie_rabbit;rabits;bun;bunny_wabbit',
    ),
    new Word.data(
      synsetId: 'bn:00033329n',
      levelId: 'animal_v1',
      lemma: 'Parrot',
      lemmas:
          'psittacidae;psittacoidea;family_psittacidae;true_parrots;true_parrot;parrot',
    ),
    new Word.data(
      synsetId: 'bn:00049156n',
      levelId: 'animal_v1',
      lemma: 'lion',
      lemmas:
          'lion;panthera_leo;king_of_beasts;african_lion;mane_of_a_lion;panthera_leo_abyssinica;addis_ababa_lion;p._leo;lions_mating;northeast_congolese_lion;eastern-southern_african_lion;social_behavior_of_lions;lions_in_ethiopia;northeast_congo_lion;panthera_leo_leo_x_panthera_leo_melanochaita;addis_abeba_lion;african_lions;🦁;reproductive_behavior_of_lions;sub-saharan_african_lion;asiatic_lion;congo_lion;lennox_anderson;lion_attack;mating_lions;central_lion;abyssinian_lion;kali;sexual_behavior_of_lions;lion\'s_penis;felis_leo;southeast_african_lion;lions_in_africa;panthera_leo_leo_and_panthera_leo_melanochaita;nakawa;east-central_african_lion;lion_penis;taxonomy_of_lions;lions;man-eating_lions;north_east_congo_lion;notch;hunting_behavior_of_lions;evolutionary_history_of_lions;middle_african_lion',
    ),
    new Word.data(
      synsetId: 'bn:00031345n',
      levelId: 'animal_v1',
      lemma: 'horse',
      lemmas:
          'horse;equus_caballus;domestic_horse;horce;equus_caballus_celticus;equus_caballus_nordicus;equus_caballus_robustus;cultural_depictions_of_horses;equus_caballus_brittanicus;equus_caballus_gracilis;domesticated_horse;equus_caballus_ewarti;equus_robustus;🐴;equus_caballus_hibernicus;equus_caballus_africanus;equine_quadraped;equus_cabalus;nag;equus_caballus_europaeus;equus_ferus_caballus;cold_blooded;equus_caballus_parvus;horsies;equus_caballus_aryanus;🐎;equus_caballus_asiaticus;equus_caballus_belgius;equus_caballus_typicus;horsie;equus_laurentius;equine_studies;equus_caballus_varius;equine_quadruped;equus_caballus_gallicus;hot_blooded;equus_caballus_cracoviensis;equus_caballus_sylvestris;horſe;equus_caballus_domesticus;equus_caballus_nehringi;equus_caballus_libycus;horses',
    ),
  ];

  static final monument_v1 = [
    new Word.data(
      synsetId: 'bn:00018485n',
      levelId: 'monument_v1',
      lemma: 'Great_Wall',
      lemmas:
          'great_wall_of_china;great_wall;chinese_wall;china\'s_great_wall;chinese_great_wall;the_great_wall;the_great_wall_of_china;wall_of_china;the_wall_of_china;china_wall;great_wal;inner_great_wall;wanli_changcheng;greate_wall;萬里長城;長城;beacon_wall;long_wall_of_china;wall_of_10,000_li;outer_great_wall;gwoc;chang_cheng;万里长城;长城;changcheng',
    ),
    new Word.data(
      synsetId: 'bn:00049459n',
      levelId: 'monument_v1',
      lemma: 'Kremlin',
      lemmas: 'kremlin;moscow_kremlin',
    ),
    new Word.data(
      synsetId: 'bn:00041586n',
      levelId: 'monument_v1',
      lemma: 'Pyramid',
      lemmas:
          'pyramid;pyramids_of_egypt;great_pyramid;egyptian_pyramids;egypt\'s_pyramids;pyramid_fields_from_giza_to_dahshur;pyramids;great_pyramid_of_giza;egyptian_pyramids_hakdog;paddle_pyramid;the_pyramid_fields_from_giza_to_dahshur;pyramidal;spanking_pyramid;ancient_egyptian_pyramids;mythical_and_miracle_power_of_pyramids;paddling_pyramid;pyrimids;abu_ruwaysh;egyptian_pyramid;piramid;pyramids_of_ancient_egypt',
    ),
    new Word.data(
      synsetId: 'bn:00050429n',
      levelId: 'monument_v1',
      lemma: 'Leaning_Tower',
      lemmas:
          'leaning_tower_of_pisa;leaning_tower;tower_of_pisa;the_leaning_tower_of_pisa;pisa_tower;leaning_tower_of_piza;leaning_tower_of_pizza;torre_di_pisa;torre_pendente_di_pisa;la_torre_di_pisa;torre_pendente;the_leaning_tower',
    ),
    new Word.data(
      synsetId: 'bn:00074065n',
      levelId: 'monument_v1',
      lemma: 'Statue_of_Liberty',
      lemmas:
          'statue_of_liberty;liberty_enlightening_the_world;la_liberté_éclairant_le_monde;the_statue_of_liberty_enlightening_the_world;staute_of_liberty;statue_of_liberty,_usa;the_statue_of_liberty;statue_liberty;statue_of_liberty_enlightening_the_world;mother_of_exiles;july_iv_mdcclxxvi;liberty,_statue_of;fort_wood_national_monument;frederick_r._law;the_liberty_statue;la_liberte_eclairant_le_monde;🗽',
    ),
    new Word.data(
      synsetId: 'bn:00052578n',
      levelId: 'monument_v1',
      lemma: 'Machu_Picchu',
      lemmas:
          'machu_picchu;macchu_picchu;macchu_pichu;machu_pichu;2010_machu_picchu_floods;macchu_piccu;idol_of_the_incas;machu_pitchu;machu_piccu;machu_pikchu;machu;machupicchu;manchu_pichu;655_44_38_99;picachu',
    ),
  ];

  static final start_v1 = [
    new Word.data(
      synsetId: 'bn:00015267n',
      levelId: 'start_v1',
      lemma: 'dog',
      lemmas:
          'dog;domestic_dog;canis_familiaris;canis_lupus_familiaris;dogs;canis_familiarus_domesticus;dogs_in_mythology;🐶;domesticated_dog;c.l._familiaris;canis_canis;canis_domesticus;dog_hood;dogs_as_pets;c._l._familiaris;pupperino;doggo;canis_familiaris_domesticus;doggo-speak;canine_lupus;pet_dogs;🐕;domestic_dogs;dogness;dogs_as_our_pets;doghood;female_dog;the_domestic_dog_clade;pupper;doggies;female_dogs;doggos;pet_dog;puppers;canis_familaris',
    ),
    new Word.data(
      synsetId: 'bn:00042379n',
      levelId: 'start_v1',
      lemma: 'water',
      lemmas:
          'h2o;water;hoh;hydrogen_hydroxide;water_surface;effects_of_water_on_life;liquid_water;[oh2];dihydrogen_monoxide;pure_water;life_and_water;h₂o;dihydridooxygen;dihydrogen_oxide;water_in_biology;hydrogen_oxide;oxidane;composition_of_water;importance_of_water;watery',
    ),
    new Word.data(
      synsetId: 'bn:00029980n',
      levelId: 'start_v1',
      lemma: 'eiffel_tower',
      lemmas:
          'eiffel_tower;tour_eiffel;the_eiffel_tower;la_tour_eiffel;eiffeltower;effiel_tower;eiffel_tower,_france;la_dame_de_fer;iffel_tower;jules_verne;eiffel_tour;eiffel_tower_paris_in_france;torre_eiffel;altitude_95;tower_eiffel;eiffle_tower;the_efiel_tower;effel_tower;eifel_tower;300-metre_tower',
    ),
    new Word.data(
      synsetId: 'bn:00013077n',
      levelId: 'start_v1',
      lemma: 'bridge',
      lemmas:
          'bridge;span;railroad_bridge;bridges;bridge_building;road_bridge;list_of_roman_bridges;rail_bridge;railway_bridge;bridge_failures;bridge_railing;🌉;bridgecraft;brigecraft;bridge_failure;bridge_railing_styles;types_of_bridges;bridge_railing_style;fixed_link;footlog;road_bridges;overway;fixed-span_bridge;double-deck_bridge;railway_bridges;foot_log',
    ),
    new Word.data(
      synsetId: 'bn:00019887n',
      levelId: 'start_v1',
      lemma: 'clock',
      lemmas:
          'clock;garage_clock;reloj;ancient_ways_of_telling_time;an_analog_clock;analogue_clock;clocks;mechanical_clock;timekeeping_device;timepieces;clock/calendar;clock_design;analog_clocks;clocks_and_watches;🕣',
    ),
  ];

  static List<Word> getLevelWords(String levelId) {
    if (levelId == "start_v1") {
      return start_v1;
    }
    if (levelId == "sport_v1") {
      return sport_v1;
    }
    if (levelId == "monument_v1") {
      return monument_v1;
    }
    if (levelId == "animal_v1") {
      return animal_v1;
    }
    if (levelId == "vehicle_v1") {
      return vehicle_v1;
    }

    return [];
  }
}
