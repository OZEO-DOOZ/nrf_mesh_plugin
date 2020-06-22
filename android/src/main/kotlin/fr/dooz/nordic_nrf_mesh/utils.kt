package fr.dooz.nordic_nrf_mesh

import java.nio.charset.StandardCharsets

private val HEX_ARRAY = "0123456789ABCDEF".toByteArray()
fun bytesToHex(bytes: ByteArray): String {
    val hexChars = ByteArray(bytes.size * 2)
    for (j in bytes.indices) {
        val v: Int = bytes[j].toInt() and 0xFF
        hexChars[j * 2] = HEX_ARRAY[v ushr 4]
        hexChars[j * 2 + 1] = HEX_ARRAY[v and 0x0F]
    }
    return String(hexChars, charset = StandardCharsets.UTF_8)
}

fun arrayListToByteArray(pdu: ArrayList<Int>): ByteArray {
    val bytes = ByteArray(pdu.size)
    for ((index, value) in pdu.withIndex()) {
        bytes[index] = value.toByte()
    }
    return bytes
}
