// a layer of 16*16 net, and do the maxpool of size of 4.
// and output a 4*4 net.
// Finally, for the 4*4 net, do the fully-connected,
// and get 4 outputs.

start:
  // firstly, maxpool the front 8 4*4 matrixs. Each element
  // is 8 bits, and maxpool the output to r0-r7.
  VMOV q0, #7101656499985446417749811181341197757318
  MOV r0, #0
  VMAXV.S8 r0, q0
  VMOV q0, #1447163071352862168344493284646355772084
  MOV r1, #0
  VMAXV.S8 r1, q0
  VMOV q0, #9419896167491740808063989887586577951168
  MOV r2, #0
  VMAXV.S8 r2, q0
  VMOV q0, #6941985641167737716528846811377828489732
  MOV r3, #0
  VMAXV.S8 r3, q0
  VMOV q0, #1033363727627029601985649396351097798283
  MOV r4, #0
  VMAXV.S8 r4, q0
  VMOV q0, #5827932009669502875666190544285247877436
  MOV r5, #0
  VMAXV.S8 r5, q0
  VMOV q0, #4924138603098770130358131084558987319475
  MOV r6, #0
  VMAXV.S8 r6, q0
  VMOV q0, #4337644267499194279942952270566116581885
  MOV r7, #0
  VMAXV.S8 r7, q0
  
  // set the output of maxpool of front 8 4*4 matrixs
  // to the vector Q1.
  VMOV.$8 q1[0], r0
  VMOV.$8 q1[1], r1
  VMOV.$8 q1[2], r2
  VMOV.$8 q1[3], r3
  VMOV.$8 q1[4], r4
  VMOV.$8 q1[5], r5
  VMOV.$8 q1[6], r6
  VMOV.$8 q1[7], r7
  
  // continue to maxpool the later 8 4*4 matrixs, and
  // output to r0-r7.
  VMOV q0, #663655083119278761867668831250121166231
  MOV r0, #0
  VMAXV.S8 r0, q0
  VMOV q0, #2600692742856490401830912406952153398413
  MOV r1, #0
  VMAXV.S8 r1, q0
  VMOV q0, #907112666069913837349867571395165964263
  MOV r2, #0
  VMAXV.S8 r2, q0
  VMOV q0, #2694932117843888001747399394048380112313
  MOV r3, #0
  VMAXV.S8 r3, q0
  VMOV q0, #9821821920241091215713474566232361892674
  MOV r4, #0
  VMAXV.S8 r4, q0
  VMOV q0, #4009198122623912839089364287453441355107
  MOV r5, #0
  VMAXV.S8 r5, q0
  VMOV q0, #6247730918379965557388463542923074116009
  MOV r6, #0
  VMAXV.S8 r6, q0
  VMOV q0, #157316759269120729406377316743496927952
  MOV r7, #0
  VMAXV.S8 r7, q0
  
  // set the rest of output of maxpool to vector Q1.
  VMOV.$8 q1[8], r0
  VMOV.$8 q1[9], r1
  VMOV.$8 q1[10], r2
  VMOV.$8 q1[11], r3
  VMOV.$8 q1[12], r4
  VMOV.$8 q1[13], r5
  VMOV.$8 q1[14], r6
  VMOV.$8 q1[15], r7
  
  // the matrix of weights of first final output 
  // is stored in Q2.
  // get the first final output of network,
  // result set to r8
  VMOV q2, #9110302564881101301142797185345813108425
  MOV r8, #0
  VMLAV.S8 r8, q1, q2
  
  // the matrix of weights of second final output 
  // is stored in Q3.
  // get the second final output of network,
  // result set to r9
  VMOV q3, #9322581109971323809051289431880843386465
  MOV r9, #0
  VMLAV.S8 r9, q1, q3
  
  // the matrix of weights of third final output 
  // is stored in Q4.
  // get the third final output of network,
  // result set to r10
  VMOV q4, #6459888891961543482907143830613458548582
  MOV r10, #0
  VMLAV.S8 r10, q1, q4
  
  // the matrix of weights of forth final output 
  // is stored in Q5.
  // get the third final output of network,
  // result set to r11
  VMOV q5, #6667587189888747373090849516989613237196
  MOV r11, #0
  VMLAV.S8 r11, q1, q5
end
