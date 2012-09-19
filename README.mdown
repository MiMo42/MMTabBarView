About dorianj/PSMTabBarControl
===
PSMTabBarControl remains the best way to have Safari-style tabs in your app. This fork makes it easy to use PSMTabBarControl when developing apps for 10.6, 10.7, and 10.8 using Xcode 4. It is also Retina-ready.

This fork contains none of the IBPlugin stuff, and removes unnecessary graphics to get a much smaller framework size (about 668kb uncompressed, 232kb deflated).

If you make any improvements, please submit them as pull requests.

Building
====

To build, simply open a terminal window in the PSMTabBarControl repo and run ./build.sh. The framework will be in build/Release.

Installing
====

Add the .framework bundle to your xcode project, and add it to the Linked Frameworks and Libraries (under Target -> Summary). Next, under Target -> Build Phases, Add  a new build phase that copies it to the Frameworks directory of your app. (Add Build Phase > Copy Files. Destination: Frameworks)

Copying
====

This package was originally created by Positive Spin Media, and is BSD licensed. See: http://www.positivespinmedia.com/dev/PSMTabBarControl.html

License
====

Copyright &copy; 2005, Positive Spin Media. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

		* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
		* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
		* Neither the name of Positive Spin Media nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
        
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
