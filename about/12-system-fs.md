# SYS FS

```
disk.map
offset
------
0x0000  ; 0 boot
0x0100  ; 1 disk.map
0x0200  ; 2 core
0x0300  ; 3 dev.map
0x0400  ; 4 drivers

disk
+----------+
|          | 0x0000 boot sector
+----------+
|          | 0x0100 disk map
+----------+
|          | 0x0200 core
+----------+
|          | 0x0300 dev.map
|          |        3057_0001 dev 1
|          |        0098_0001 dev 2
|          |        0098_0002 dev 3
+----------+
|          | 
|          | 
|          | 
+----------+
```
