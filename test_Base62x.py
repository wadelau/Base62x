"""
    Unit Test Case for Base62x
"""

from unittest import TestCase
from Base62x import Base62x


class testBase62x(TestCase):

    def test_encoding(self):
        B = Base62x()
        # ASCII
        self.assertEqual(B.encode('hello'), 'hellox')
        self.assertEqual(B.encode('123'), '123x')
        self.assertEqual(B.encode("""kajsdlfj12943u2oijrfsaj;la'jlakjf;kjofijwoenv\\]`~!@~#$%^&*&O+_=-"""), 'kajsdlfj12943u2oijrfsajxilaxYjlakjfxikjofijwoenvxpxqxtxyxSxnxyxUxVxWxrxXxbxXOxcxsxkxex')  # NOQA
        # Unicode
        self.assertEqual(B.encode('你好'), 'vBsWvQMx1')
        self.assertEqual(B.encode('🛩🛸⚱️●❖⍡🙂🤩'), 'z9x2RgV2VcyZYch7lk8x3Ybux3YdPRYZQ7mdvc2z9x2ag1')

    def test_decoding(self):
        B = Base62x()
        # ASCII
        self.assertEqual(B.decode('hellox'), 'hello')
        self.assertEqual(B.decode('123x'), '123')
        self.assertEqual(B.decode('kajsdlfj12943u2oijrfsajxilaxYjlakjfxikjofijwoenvxpxqxtxyxSxnxyxUxVxWxrxXxbxXOxcxsxkxex'), """kajsdlfj12943u2oijrfsaj;la'jlakjf;kjofijwoenv\\]`~!@~#$%^&*&O+_=-""")  # NOQA

    def test_encoding_decoding(self):
        B = Base62x()
        s1 = 'kajsdlfj12943u2oijrfsajxilaxYjlakjfxikjofijwoenvxpxqxtxyxSxnxyxUxVxWxrxXxbxXOxcxsxkxex'
        s2 = '你好吗'
        self.assertEqual(B.decode(B.encode(s1)), s1)
        self.assertEqual(B.decode(B.encode(s2)), s2)

    def test_errors(self):
        B = Base62x()
        with self.assertRaises(TypeError):
            B.encode(123)
            B.decode(123)
        with self.assertRaises(KeyError):
            B.decode('some random thing: alksjflajlfjw32093r29')
