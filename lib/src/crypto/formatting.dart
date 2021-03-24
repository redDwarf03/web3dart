// @dart=2.9
part of 'package:web3dart/crypto.dart';

/// If present, removes the 0x from the start of a hex-string.
String strip0x(String hex) {
  if (hex.startsWith('0x')) return hex.substring(2);
  return hex;
}

/// Converts the [bytes] given as a list of integers into a hexadecimal
/// representation.
///
/// If any of the bytes is outside of the range [0, 256], the method will throw.
/// The outcome of this function will prefix a 0 if it would otherwise not be
/// of even length. If [include0x] is set, it will prefix "0x" to the hexadecimal
/// representation. If [forcePadLength] is set, the hexadecimal representation
/// will be expanded with zeroes until the desired length is reached. The "0x"
/// prefix does not count for the length.
String bytesToHex(List<int> bytes,
    {bool include0x = false,
    int forcePadLength,
    bool padToEvenLength = false}) {
  var encoded = hex.encode(bytes);

  if (forcePadLength != null) {
    assert(forcePadLength >= encoded.length);

    final padding = forcePadLength - encoded.length;
    encoded = ('0' * padding) + encoded;
  }

  if (padToEvenLength && encoded.length % 2 != 0) {
    encoded = '0$encoded';
  }

  return (include0x ? '0x' : '') + encoded;
}

/// Converts the hexadecimal string, which can be prefixed with 0x, to a byte
/// sequence.
Uint8List hexToBytes(String hexStr) {
  final bytes = hex.decode(strip0x(hexStr));
  if (bytes is Uint8List) return bytes;

  return Uint8List.fromList(bytes);
}


///Converts the bytes from that list (big endian) to an unsigned BigInt.
BigInt bytesToInt(List<int> bytes) => _decodeBigInt(bytes);

Uint8List intToBytes(BigInt number) => _encodeBigInt(number);

///Takes the hexadecimal input and creates a [BigInt].
BigInt hexToInt(String hex) {
  return BigInt.parse(strip0x(hex), radix: 16);
}

/// Converts the hexadecimal input and creates an [int].
int hexToDartInt(String hex) {
  return int.parse(strip0x(hex), radix: 16);
}

var _byteMask = new BigInt.from(0xff);

/// Encode a BigInt into bytes using big-endian encoding.
Uint8List _encodeBigInt(BigInt number) {
  // Not handling negative numbers. Decide how you want to do that.
  int size = (number.bitLength + 7) >> 3;
  var result = new Uint8List(size);
  for (int i = 0; i < size; i++) {
    result[size - i - 1] = (number & _byteMask).toInt();
    number = number >> 8;
  }
  return result;
}

/// Decode a BigInt from bytes in big-endian encoding.
BigInt _decodeBigInt(List<int> bytes) {
  BigInt result = BigInt.from(0);
  //
  for (int i = 0; i < bytes.length; i++) {
    result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result;
}