#import "ImapEncoding.h"

// From http://www.opensource.apple.com/source/WebCore/WebCore-106/kwq/KWQCharsets.mm
// Commented chinese stuff, wouldn't compile


enum KWQEncodingFlags {
    NoEncodingFlags = 0,
    VisualOrdering = 1,
    BigEndian = 2,
    LittleEndian = 4,
    IsJapanese = 8
};

struct CharsetEntry {
    const char *name;
    CFStringEncoding encoding;
    KWQEncodingFlags flags;
};

static const CharsetEntry table[] = {
    { "macintosh", kCFStringEncodingMacRoman, NoEncodingFlags },
    { "csmacintosh", kCFStringEncodingMacRoman, NoEncodingFlags },
    { "mac", kCFStringEncodingMacRoman, NoEncodingFlags },
    { "xmacroman", kCFStringEncodingMacRoman, NoEncodingFlags },
    { "windows-1252", kCFStringEncodingWindowsLatin1, NoEncodingFlags },
    { "winlatin1", kCFStringEncodingWindowsLatin1, NoEncodingFlags },
    { "xansi", kCFStringEncodingWindowsLatin1, NoEncodingFlags },
    { "ISO-8859-1", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "88591", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "cp819", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "csisolatin1", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "ibm819", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "iso885911987", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "isoir100", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "l1", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "latin1", kCFStringEncodingISOLatin1, NoEncodingFlags },
    { "x-nextstep", kCFStringEncodingNextStepLatin, NoEncodingFlags },
    { "US-ASCII", kCFStringEncodingASCII, NoEncodingFlags },
    { "ansix341968", kCFStringEncodingASCII, NoEncodingFlags },
    { "ansix341986", kCFStringEncodingASCII, NoEncodingFlags },
    { "ascii", kCFStringEncodingASCII, NoEncodingFlags },
    { "cp367", kCFStringEncodingASCII, NoEncodingFlags },
    { "csascii", kCFStringEncodingASCII, NoEncodingFlags },
    { "ibm367", kCFStringEncodingASCII, NoEncodingFlags },
    { "iso646irv1991", kCFStringEncodingASCII, NoEncodingFlags },
    { "iso646us", kCFStringEncodingASCII, NoEncodingFlags },
    { "isoir6", kCFStringEncodingASCII, NoEncodingFlags },
    { "isoir6us", kCFStringEncodingASCII, NoEncodingFlags },
    { "us", kCFStringEncodingASCII, NoEncodingFlags },
    { "ISO-10646-UCS-2", kCFStringEncodingUnicode, NoEncodingFlags },
    { "csunicode", kCFStringEncodingUnicode, NoEncodingFlags },
    { "ucs2", kCFStringEncodingUnicode, NoEncodingFlags },
    { "unicode", kCFStringEncodingUnicode, NoEncodingFlags },
    { "utf16", kCFStringEncodingUnicode, NoEncodingFlags },
    { "UTF-16BE", kCFStringEncodingUnicode, BigEndian },
    { "unicodefffe", kCFStringEncodingUnicode, BigEndian },
    { "UTF-16LE", kCFStringEncodingUnicode, LittleEndian },
    { "unicodefeff", kCFStringEncodingUnicode, LittleEndian },
    { "UTF-8", kCFStringEncodingUTF8, NoEncodingFlags },
    { "unicode11utf8", kCFStringEncodingUTF8, NoEncodingFlags },
    { "unicode20utf8", kCFStringEncodingUTF8, NoEncodingFlags },
    { "xunicode20utf8", kCFStringEncodingUTF8, NoEncodingFlags },
    { "x-mac-japanese", kCFStringEncodingMacJapanese, IsJapanese },
    { "x-mac-chinesetrad", kCFStringEncodingMacChineseTrad, NoEncodingFlags },
    { "xmactradchinese", kCFStringEncodingMacChineseTrad, NoEncodingFlags },
    { "x-mac-korean", kCFStringEncodingMacKorean, NoEncodingFlags },
    { "x-mac-arabic", kCFStringEncodingMacArabic, NoEncodingFlags },
    { "x-mac-hebrew", kCFStringEncodingMacHebrew, NoEncodingFlags },
    { "x-mac-greek", kCFStringEncodingMacGreek, NoEncodingFlags },
    { "x-mac-cyrillic", kCFStringEncodingMacCyrillic, NoEncodingFlags },
    { "xmacukrainian", kCFStringEncodingMacCyrillic, NoEncodingFlags },
    { "x-mac-devanagari", kCFStringEncodingMacDevanagari, NoEncodingFlags },
    { "x-mac-gurmukhi", kCFStringEncodingMacGurmukhi, NoEncodingFlags },
    { "x-mac-gujarati", kCFStringEncodingMacGujarati, NoEncodingFlags },
    { "x-mac-thai", kCFStringEncodingMacThai, NoEncodingFlags },
    { "x-mac-chinesesimp", kCFStringEncodingMacChineseSimp, NoEncodingFlags },
    { "xmacsimpchinese", kCFStringEncodingMacChineseSimp, NoEncodingFlags },
    { "x-mac-tibetan", kCFStringEncodingMacTibetan, NoEncodingFlags },
    { "x-mac-centraleurroman", kCFStringEncodingMacCentralEurRoman, NoEncodingFlags },
    { "xmacce", kCFStringEncodingMacCentralEurRoman, NoEncodingFlags },
    { "x-mac-symbol", kCFStringEncodingMacSymbol, NoEncodingFlags },
    { "x-mac-dingbats", kCFStringEncodingMacDingbats, NoEncodingFlags },
    { "x-mac-turkish", kCFStringEncodingMacTurkish, NoEncodingFlags },
    { "x-mac-croatian", kCFStringEncodingMacCroatian, NoEncodingFlags },
    { "x-mac-icelandic", kCFStringEncodingMacIcelandic, NoEncodingFlags },
    { "x-mac-romanian", kCFStringEncodingMacRomanian, NoEncodingFlags },
    { "x-mac-farsi", kCFStringEncodingMacFarsi, NoEncodingFlags },
    { "x-mac-vt100", kCFStringEncodingMacVT100, NoEncodingFlags },
    { "ISO-8859-2", kCFStringEncodingISOLatin2, NoEncodingFlags },
    { "csisolatin2", kCFStringEncodingISOLatin2, NoEncodingFlags },
    { "iso885921987", kCFStringEncodingISOLatin2, NoEncodingFlags },
    { "isoir101", kCFStringEncodingISOLatin2, NoEncodingFlags },
    { "l2", kCFStringEncodingISOLatin2, NoEncodingFlags },
    { "latin2", kCFStringEncodingISOLatin2, NoEncodingFlags },
    { "ISO-8859-3", kCFStringEncodingISOLatin3, NoEncodingFlags },
    { "csisolatin3", kCFStringEncodingISOLatin3, NoEncodingFlags },
    { "iso885931988", kCFStringEncodingISOLatin3, NoEncodingFlags },
    { "isoir109", kCFStringEncodingISOLatin3, NoEncodingFlags },
    { "l3", kCFStringEncodingISOLatin3, NoEncodingFlags },
    { "latin3", kCFStringEncodingISOLatin3, NoEncodingFlags },
    { "ISO-8859-4", kCFStringEncodingISOLatin4, NoEncodingFlags },
    { "csisolatin4", kCFStringEncodingISOLatin4, NoEncodingFlags },
    { "iso885941988", kCFStringEncodingISOLatin4, NoEncodingFlags },
    { "isoir110", kCFStringEncodingISOLatin4, NoEncodingFlags },
    { "l4", kCFStringEncodingISOLatin4, NoEncodingFlags },
    { "latin4", kCFStringEncodingISOLatin4, NoEncodingFlags },
    { "ISO-8859-5", kCFStringEncodingISOLatinCyrillic, NoEncodingFlags },
    { "csisolatincyrillic", kCFStringEncodingISOLatinCyrillic, NoEncodingFlags },
    { "cyrillic", kCFStringEncodingISOLatinCyrillic, NoEncodingFlags },
    { "iso885951988", kCFStringEncodingISOLatinCyrillic, NoEncodingFlags },
    { "isoir144", kCFStringEncodingISOLatinCyrillic, NoEncodingFlags },
    { "ISO-8859-6", kCFStringEncodingISOLatinArabic, NoEncodingFlags },
    { "arabic", kCFStringEncodingISOLatinArabic, NoEncodingFlags },
    { "asmo708", kCFStringEncodingISOLatinArabic, NoEncodingFlags },
    { "csisolatinarabic", kCFStringEncodingISOLatinArabic, NoEncodingFlags },
    { "ecma114", kCFStringEncodingISOLatinArabic, NoEncodingFlags },
    { "iso885961987", kCFStringEncodingISOLatinArabic, NoEncodingFlags },
    { "isoir127", kCFStringEncodingISOLatinArabic, NoEncodingFlags },
    { "ISO-8859-7", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "csisolatingreek", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "ecma118", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "elot928", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "greek", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "greek8", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "iso885971987", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "isoir126", kCFStringEncodingISOLatinGreek, NoEncodingFlags },
    { "ISO-8859-8-I", kCFStringEncodingISOLatinHebrew, NoEncodingFlags },
    { "csiso88598i", kCFStringEncodingISOLatinHebrew, NoEncodingFlags },
    { "logical", kCFStringEncodingISOLatinHebrew, NoEncodingFlags },
    { "ISO-8859-8-E", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "csiso88598e", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "csisolatinhebrew", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "dos862", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "hebrew", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "iso88598", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "iso885981988", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "isoir138", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "visual", kCFStringEncodingISOLatinHebrew, VisualOrdering },
    { "ISO-8859-9", kCFStringEncodingISOLatin5, NoEncodingFlags },
    { "csisolatin5", kCFStringEncodingISOLatin5, NoEncodingFlags },
    { "iso885991989", kCFStringEncodingISOLatin5, NoEncodingFlags },
    { "isoir148", kCFStringEncodingISOLatin5, NoEncodingFlags },
    { "l5", kCFStringEncodingISOLatin5, NoEncodingFlags },
    { "latin5", kCFStringEncodingISOLatin5, NoEncodingFlags },
    { "ISO-8859-10", kCFStringEncodingISOLatin6, NoEncodingFlags },
    { "csisolatin6", kCFStringEncodingISOLatin6, NoEncodingFlags },
    { "iso8859101992", kCFStringEncodingISOLatin6, NoEncodingFlags },
    { "isoir157", kCFStringEncodingISOLatin6, NoEncodingFlags },
    { "l6", kCFStringEncodingISOLatin6, NoEncodingFlags },
    { "latin6", kCFStringEncodingISOLatin6, NoEncodingFlags },
    { "ISO-8859-11", kCFStringEncodingISOLatinThai, NoEncodingFlags },
    { "ISO-8859-13", kCFStringEncodingISOLatin7, NoEncodingFlags },
    { "ISO-8859-14", kCFStringEncodingISOLatin8, NoEncodingFlags },
    { "iso8859141998", kCFStringEncodingISOLatin8, NoEncodingFlags },
    { "isoceltic", kCFStringEncodingISOLatin8, NoEncodingFlags },
    { "isoir199", kCFStringEncodingISOLatin8, NoEncodingFlags },
    { "l8", kCFStringEncodingISOLatin8, NoEncodingFlags },
    { "latin8", kCFStringEncodingISOLatin8, NoEncodingFlags },
    { "ISO-8859-15", kCFStringEncodingISOLatin9, NoEncodingFlags },
    { "csisolatin9", kCFStringEncodingISOLatin9, NoEncodingFlags },
    { "l9", kCFStringEncodingISOLatin9, NoEncodingFlags },
    { "latin9", kCFStringEncodingISOLatin9, NoEncodingFlags },
    { "ISO-8859-16", kCFStringEncodingISOLatin10, NoEncodingFlags },
    { "iso8859162001", kCFStringEncodingISOLatin10, NoEncodingFlags },
    { "isoir226", kCFStringEncodingISOLatin10, NoEncodingFlags },
    { "l10", kCFStringEncodingISOLatin10, NoEncodingFlags },
    { "latin10", kCFStringEncodingISOLatin10, NoEncodingFlags },
    { "cp437", kCFStringEncodingDOSLatinUS, NoEncodingFlags },
    { "437", kCFStringEncodingDOSLatinUS, NoEncodingFlags },
    { "cspc8codepage437", kCFStringEncodingDOSLatinUS, NoEncodingFlags },
    { "ibm437", kCFStringEncodingDOSLatinUS, NoEncodingFlags },
    { "cp737", kCFStringEncodingDOSGreek, NoEncodingFlags },
    { "ibm737", kCFStringEncodingDOSGreek, NoEncodingFlags },
    { "cp500", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "cp775", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "csibm500", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "cspc775baltic", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "ebcdiccpbe", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "ebcdiccpch", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "ibm500", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "ibm775", kCFStringEncodingDOSBalticRim, NoEncodingFlags },
    { "cp850", kCFStringEncodingDOSLatin1, NoEncodingFlags },
    { "850", kCFStringEncodingDOSLatin1, NoEncodingFlags },
    { "cspc850multilingual", kCFStringEncodingDOSLatin1, NoEncodingFlags },
    { "ibm850", kCFStringEncodingDOSLatin1, NoEncodingFlags },
    { "cp852", kCFStringEncodingDOSLatin2, NoEncodingFlags },
    { "852", kCFStringEncodingDOSLatin2, NoEncodingFlags },
    { "cspcp852", kCFStringEncodingDOSLatin2, NoEncodingFlags },
    { "ibm852", kCFStringEncodingDOSLatin2, NoEncodingFlags },
    { "cp857", kCFStringEncodingDOSTurkish, NoEncodingFlags },
    { "857", kCFStringEncodingDOSTurkish, NoEncodingFlags },
    { "csibm857", kCFStringEncodingDOSTurkish, NoEncodingFlags },
    { "ibm857", kCFStringEncodingDOSTurkish, NoEncodingFlags },
    { "cp861", kCFStringEncodingDOSIcelandic, NoEncodingFlags },
    { "861", kCFStringEncodingDOSIcelandic, NoEncodingFlags },
    { "cpis", kCFStringEncodingDOSIcelandic, NoEncodingFlags },
    { "csibm861", kCFStringEncodingDOSIcelandic, NoEncodingFlags },
    { "ibm861", kCFStringEncodingDOSIcelandic, NoEncodingFlags },
    { "cp864", kCFStringEncodingDOSArabic, NoEncodingFlags },
    { "csibm864", kCFStringEncodingDOSArabic, NoEncodingFlags },
    { "dos720", kCFStringEncodingDOSArabic, NoEncodingFlags },
    { "ibm864", kCFStringEncodingDOSArabic, NoEncodingFlags },
    { "cp866", kCFStringEncodingDOSRussian, NoEncodingFlags },
    { "866", kCFStringEncodingDOSRussian, NoEncodingFlags },
    { "csibm866", kCFStringEncodingDOSRussian, NoEncodingFlags },
    { "ibm866", kCFStringEncodingDOSRussian, NoEncodingFlags },
    { "cp869", kCFStringEncodingDOSGreek2, NoEncodingFlags },
    { "869", kCFStringEncodingDOSGreek2, NoEncodingFlags },
    { "cpgr", kCFStringEncodingDOSGreek2, NoEncodingFlags },
    { "csibm869", kCFStringEncodingDOSGreek2, NoEncodingFlags },
    { "ibm869", kCFStringEncodingDOSGreek2, NoEncodingFlags },
    { "cp874", kCFStringEncodingDOSThai, NoEncodingFlags },
    { "dos874", kCFStringEncodingDOSThai, NoEncodingFlags },
    { "tis620", kCFStringEncodingDOSThai, NoEncodingFlags },
    { "windows874", kCFStringEncodingDOSThai, NoEncodingFlags },
    { "cp932", kCFStringEncodingDOSJapanese, IsJapanese },
    { "cswindows31j", kCFStringEncodingDOSJapanese, IsJapanese },
    { "windows31j", kCFStringEncodingDOSJapanese, IsJapanese },
    { "xmscp932", kCFStringEncodingDOSJapanese, IsJapanese },
    { "cp950", kCFStringEncodingDOSChineseTrad, NoEncodingFlags },
    { "windows-1250", kCFStringEncodingWindowsLatin2, NoEncodingFlags },
    { "winlatin2", kCFStringEncodingWindowsLatin2, NoEncodingFlags },
    { "xcp1250", kCFStringEncodingWindowsLatin2, NoEncodingFlags },
    { "windows-1251", kCFStringEncodingWindowsCyrillic, NoEncodingFlags },
    { "wincyrillic", kCFStringEncodingWindowsCyrillic, NoEncodingFlags },
    { "xcp1251", kCFStringEncodingWindowsCyrillic, NoEncodingFlags },
    { "windows-1253", kCFStringEncodingWindowsGreek, NoEncodingFlags },
    { "wingreek", kCFStringEncodingWindowsGreek, NoEncodingFlags },
    { "windows-1254", kCFStringEncodingWindowsLatin5, NoEncodingFlags },
    { "winturkish", kCFStringEncodingWindowsLatin5, NoEncodingFlags },
    { "windows-1255", kCFStringEncodingWindowsHebrew, NoEncodingFlags },
    { "winhebrew", kCFStringEncodingWindowsHebrew, NoEncodingFlags },
    { "windows-1256", kCFStringEncodingWindowsArabic, NoEncodingFlags },
    { "cp1256", kCFStringEncodingWindowsArabic, NoEncodingFlags },
    { "winarabic", kCFStringEncodingWindowsArabic, NoEncodingFlags },
    { "windows-1257", kCFStringEncodingWindowsBalticRim, NoEncodingFlags },
    { "winbaltic", kCFStringEncodingWindowsBalticRim, NoEncodingFlags },
    { "johab", kCFStringEncodingWindowsKoreanJohab, NoEncodingFlags },
    { "windows-1258", kCFStringEncodingWindowsVietnamese, NoEncodingFlags },
    { "winvietnamese", kCFStringEncodingWindowsVietnamese, NoEncodingFlags },
    { "JIS_X0201", kCFStringEncodingJIS_X0201_76, IsJapanese },
    { "cshalfwidthkatakana", kCFStringEncodingJIS_X0201_76, IsJapanese },
    { "x0201", kCFStringEncodingJIS_X0201_76, IsJapanese },
    { "JIS_X0208-1983", kCFStringEncodingJIS_X0208_83, IsJapanese },
    { "csiso87jisx0208", kCFStringEncodingJIS_X0208_83, IsJapanese },
    { "isoir87", kCFStringEncodingJIS_X0208_83, IsJapanese },
    { "jisc62261983", kCFStringEncodingJIS_X0208_83, IsJapanese },
    { "x0208", kCFStringEncodingJIS_X0208_83, IsJapanese },
    { "JIS_X0208-1990", kCFStringEncodingJIS_X0208_90, IsJapanese },
    { "JIS_X0212-1990", kCFStringEncodingJIS_X0212_90, IsJapanese },
    { "csiso159jisx02121990", kCFStringEncodingJIS_X0212_90, IsJapanese },
    { "isoir159", kCFStringEncodingJIS_X0212_90, IsJapanese },
    { "x0212", kCFStringEncodingJIS_X0212_90, IsJapanese },
    { "JIS_C6226-1978", kCFStringEncodingJIS_C6226_78, IsJapanese },
    { "csiso42jisc62261978", kCFStringEncodingJIS_C6226_78, IsJapanese },
    { "isoir42", kCFStringEncodingJIS_C6226_78, IsJapanese },
    { "Shift_JIS_X0213-2000", kCFStringEncodingShiftJIS_X0213_00, IsJapanese },
    { "GB18030", kCFStringEncodingGB_18030_2000, NoEncodingFlags },
    { "ISO-2022-JP", kCFStringEncodingISO_2022_JP, IsJapanese },
    { "csiso2022jp", kCFStringEncodingISO_2022_JP, IsJapanese },
    { "jis7", kCFStringEncodingISO_2022_JP, IsJapanese },
    { "ISO-2022-JP-2", kCFStringEncodingISO_2022_JP_2, IsJapanese },
    { "csiso2022jp2", kCFStringEncodingISO_2022_JP_2, IsJapanese },
    { "ISO-2022-JP-1", kCFStringEncodingISO_2022_JP_1, IsJapanese },
    { "ISO-2022-JP-3", kCFStringEncodingISO_2022_JP_3, IsJapanese },
    { "ISO-2022-CN", kCFStringEncodingISO_2022_CN, NoEncodingFlags },
    { "ISO-2022-CN-EXT", kCFStringEncodingISO_2022_CN_EXT, NoEncodingFlags },
    { "ISO-2022-KR", kCFStringEncodingISO_2022_KR, NoEncodingFlags },
    { "csiso2022kr", kCFStringEncodingISO_2022_KR, NoEncodingFlags },
    { "EUC-JP", kCFStringEncodingEUC_JP, IsJapanese },
    { "cseucpkdfmtjapanese", kCFStringEncodingEUC_JP, IsJapanese },
    { "extendedunixcodepackedformatforjapanese", kCFStringEncodingEUC_JP, IsJapanese },
    { "xeuc", kCFStringEncodingEUC_JP, IsJapanese },
    { "xeucjp", kCFStringEncodingEUC_JP, IsJapanese },
/*
    { "EUC-CN", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "chinese", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "cngb", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "cp936", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "csgb2312", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "csgb231280", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "csiso58gb231280", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "gb2312", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "gb231280", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "gbk", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "isoir58", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "ms936", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "windows936", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "xeuccn", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "xgbk", kCFStringEncodingEUC_CN_DOSVariant, NoEncodingFlags },
    { "EUC-TW", kCFStringEncodingEUC_TW, NoEncodingFlags },
    { "EUC-KR", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "cp949", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "cseuckr", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "csksc56011987", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "isoir149", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "korean", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "ksc5601", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "ksc56011987", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "ksc56011989", kCFStringEncodingEUC_KR_DOSVariant, NoEncodingFlags },
    { "Shift_JIS", kCFStringEncodingShiftJIS_DOSVariant, IsJapanese },
    { "csshiftjis", kCFStringEncodingShiftJIS_DOSVariant, IsJapanese },
    { "mskanji", kCFStringEncodingShiftJIS_DOSVariant, IsJapanese },
    { "sjis", kCFStringEncodingShiftJIS_DOSVariant, IsJapanese },
    { "xsjis", kCFStringEncodingShiftJIS_DOSVariant, IsJapanese },
*/
    { "KOI8-R", kCFStringEncodingKOI8_R, NoEncodingFlags },
    { "cskoi8r", kCFStringEncodingKOI8_R, NoEncodingFlags },
    { "koi", kCFStringEncodingKOI8_R, NoEncodingFlags },
    { "koi8", kCFStringEncodingKOI8_R, NoEncodingFlags },
/*
    { "Big5", kCFStringEncodingBig5_DOSVariant, NoEncodingFlags },
    { "cnbig5", kCFStringEncodingBig5_DOSVariant, NoEncodingFlags },
    { "csbig5", kCFStringEncodingBig5_DOSVariant, NoEncodingFlags },
    { "xxbig5", kCFStringEncodingBig5_DOSVariant, NoEncodingFlags },
*/
    { "x-mac-roman-latin1", kCFStringEncodingMacRomanLatin1, NoEncodingFlags },
    { "HZ-GB-2312", kCFStringEncodingHZ_GB_2312, NoEncodingFlags },
    { "Big5-HKSCS", kCFStringEncodingBig5_HKSCS_1999, NoEncodingFlags },
    { "KOI8-U", kCFStringEncodingKOI8_U, NoEncodingFlags },
    { "cp037", kCFStringEncodingEBCDIC_CP037, NoEncodingFlags },
    { "csibm037", kCFStringEncodingEBCDIC_CP037, NoEncodingFlags },
    { "ebcdiccpca", kCFStringEncodingEBCDIC_CP037, NoEncodingFlags },
    { "ebcdiccpnl", kCFStringEncodingEBCDIC_CP037, NoEncodingFlags },
    { "ebcdiccpus", kCFStringEncodingEBCDIC_CP037, NoEncodingFlags },
    { "ebcdiccpwt", kCFStringEncodingEBCDIC_CP037, NoEncodingFlags },
    { "ibm037", kCFStringEncodingEBCDIC_CP037, NoEncodingFlags },
    { 0, kCFStringEncodingInvalidId, NoEncodingFlags }
};



static CFMutableDictionaryRef nameToTable = NULL;
static CFMutableDictionaryRef encodingToTable = NULL;

static Boolean encodingNamesEqual(const void *value1, const void *value2)
{
    const char *s1 = static_cast<const char *>(value1);
    const char *s2 = static_cast<const char *>(value2);
    
    while (1) {
        char c1;
        do {
            c1 = *s1++;
        } while (c1 && !isalnum(c1));
        char c2;
        do {
            c2 = *s2++;
        } while (c2 && !isalnum(c2));
        
        if (tolower(c1) != tolower(c2)) {
            return false;
        }
        
        if (!c1 || !c2) {
            return !c1 && !c2;
        }
    }
}

// Golden ratio - arbitrary start value to avoid mapping all 0's to all 0's
// or anything like that.
const unsigned PHI = 0x9e3779b9U;

// This hash algorithm comes from:
// http://burtleburtle.net/bob/hash/hashfaq.html
// http://burtleburtle.net/bob/hash/doobs.html
static CFHashCode encodingNameHash(const void *value)
{
    const char *s = static_cast<const char *>(value);
    
    CFHashCode h = PHI;

    for (int i = 0; i != MIN(16, strlen(s)); ++i) {
        char c;
        do {
            c = *s++;
        } while (c && !isalnum(c));
        if (!c) {
            break;
        }
        h += tolower(c);
				h += (h << 10); 
				h ^= (h << 6); 
    }

    h += (h << 3);
    h ^= (h >> 11);
    h += (h << 15);
 
    return h;
}

static const CFDictionaryKeyCallBacks encodingNameKeyCallbacks = { 0, NULL, NULL, NULL, encodingNamesEqual, encodingNameHash };

static void buildDictionaries()
{
    nameToTable = CFDictionaryCreateMutable(NULL, 0, &encodingNameKeyCallbacks, NULL);
    encodingToTable = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);

    for (int i = 0; table[i].name != NULL; i++) {
        CFDictionaryAddValue(nameToTable, table[i].name, &table[i]);
        CFDictionaryAddValue(encodingToTable, reinterpret_cast<void *>(table[i].encoding), &table[i]);
    }
}

CFStringEncoding KWQCFStringEncodingFromIANACharsetName(const char *name, KWQEncodingFlags *flags)
{
    if (nameToTable == NULL) {
        buildDictionaries();
    }

    const void *value;
    if (!CFDictionaryGetValueIfPresent(nameToTable, name, &value)) {
        if (flags) {
            *flags = NoEncodingFlags;
        }
        return kCFStringEncodingInvalidId;
    }
    if (flags) {
        *flags = static_cast<const CharsetEntry *>(value)->flags;
    }
		const CharsetEntry *entry = static_cast<const CharsetEntry *>(value);
    return entry->encoding;
}


@implementation ImapEncoding

+ (CFStringEncoding) encodingFromName:(NSString *)name
{
	CFStringEncoding result = CFStringConvertEncodingToNSStringEncoding(
		KWQCFStringEncodingFromIANACharsetName([name UTF8String], NULL));
	if (result == kCFStringEncodingInvalidId)
		return NSUTF8StringEncoding;
	else
		return result;
}

@end
