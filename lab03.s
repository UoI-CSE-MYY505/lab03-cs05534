# Conversion of RGB888 image to RGB565
# lab03 of MYY505 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou
.globl rgb888_to_rgb565, showImage
.data
image888:  
    .byte 255, 0,     0
    .byte 255,  85,   0
    .byte 255, 170,   0
    .byte 255, 255,   0
    .byte 170, 255,   0
    .byte  85, 255,   0
    .byte   0, 255,   0
    .byte   0, 255,  85
    .byte   0, 255, 170
    .byte   0, 255, 255
    .byte   0, 170, 255
    .byte   0,  85, 255
    .byte   0,   0, 255
    .byte  85,   0, 255
    .byte 170,   0, 255
    .byte 255,   0, 255
    .byte 255,   0, 170
    .byte 255,   0,  85
    .byte 255,   0,   0
# repeat the above 5 times
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0

image565:
    .zero 512  # leave a 0.5Kibyte free space
.text
    la   a0, image888
    la   a3, image565
    li   a1, 19 # width
    li   a2,  6 # height
    jal  ra, rgb888_to_rgb565

    addi a7, zero, 10 
    ecall
showImage:
    add  t0, zero, zero # row counter
showRowLoop:
    bge  t0, a3, outShowRowLoop
    add  t1, zero, zero # column counter
showColumnLoop:
    bge  t1, a2, outShowColumnLoop
    lbu  t2, 0(a0) # get red
    lbu  t3, 1(a0) # get green
    lbu  t4, 2(a0) # get blue
    slli t2, t2, 16  # place red at the 3rd byte of "led" word
    slli t3, t3, 8   #   green at the 2nd
    or   t4, t4, t3  # combine green, blue
    or   t4, t4, t2  # Add red to the above
    sw   t4, 0(a1)   # let there be light at this pixel
    addi a0, a0, 3   # move on to the next image pixel
    addi a1, a1, 4   # move on to the next LED
    addi t1, t1, 1
    j    showColumnLoop
outShowColumnLoop:
    addi t0, t0, 1
    j    showRowLoop
outShowRowLoop:
    jalr zero, ra, 0
rgb888_to_rgb565:
    add  t0, zero, zero # row counter
rowLoop:
    bge  t0, a2, outRowLoop
    add  t1, zero, zero # column counter
columnLoop:
    bge  t1, a1, outColumnLoop
    lbu  t2, 0(a0)   # r
    lbu  t3, 1(a0)   # g
    lbu  t4, 2(a0)   # b
    andi t2, t2, 0xf8   # clear 3 lsbs
    slli t2, t2, 8      # shift to final place of R in RGB565 format
    andi t3, t3, 0xfc   # clear 2 lsbs
    slli t3, t3, 3      # shift to final place of G in RGB565 format
    srli t4, t4, 3      # remove 3 lsbs of blue
    or   t2, t2, t3
    or   t2, t2, t4
    sh   t2, 0(a3)   # store 16bits (half word) in RGB565 format to output
    addi a0, a0, 3   # move input pointer to next pixel
    addi a3, a3, 2   # move ouput pointer to next pixel
    addi t1, t1, 1
    j    columnLoop
outColumnLoop:
    addi t0, t0, 1
    j    rowLoop
outRowLoop:
    jalr zero, ra, 0
rgb565_to_rgb888:
    add  t0, zero, zero # row counter
rowl:
    bge  t0, a2, outRowl
    add  t1, zero, zero # column counter
columnl:
    bge  t1, a1, outColumnl
    lhu  t2, 0(a0)
    srli t3, t2, 8  # extract red (3 lsbs still from green)
    andi t3, t3, 0xf8 # clear 3 lsbs
    sb   t3, 0(a3) # store in out image
    srli t3, t2, 3  # extract green (2 lsbs still from blue)
    andi t3, t3, 0xfc # clear 2 lsbs
    sb   t3, 1(a3) # store in out image
    slli t3, t2, 3
    andi t3, t3, 0xf8 # clear 3 lsbs
    sb   t3, 3(a3) # store in out image
    addi a0, a0, 2   # move input pointer to next pixel
    addi a3, a3, 3   # move ouput pointer to next pixel
    addi t1, t1, 1
    j    columnl
outColumnl:
    addi t0, t0, 1
    j    rowl
outRowl:
    jalr zero, ra, 0


 


