#!/usr/bin/env python3

import paralleldots

api_key = "4XqGkMlhGvO3sIr3PFliJbblTdfhM8O0NYAVnItsiJM"
paralleldots.set_api_key( api_key )
text      = "Chipotle in the north of Chicago is a nice outlet. I went to this place for their famous burritos but fell in love with their healthy avocado salads. Our server Jessica was very helpful. pop in again soon!"
print (paralleldots.emotion( text ))
