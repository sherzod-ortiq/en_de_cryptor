# A CLI program for text encryption and decryption

This program uses AES encyption 

## How to use

```bash
cd en_de_cryptor
dart pub get
dart run ./bin/en_de_cryptor.dart <operation_type_flag> <file_path>
```
### operation_type_flag
There are two operations:
1. -e or --encrypt
2. -d or --decrypt

### file_path
Any valid text file path

## Known issues
Text file is read not by chunks, but at once, and there could be problems while
working with big files.