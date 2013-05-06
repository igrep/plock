# Plock

p + block = plock. 'p { 1 + 1 }` prints "(1 + 1) #=> 2". That's all.

# Usage

After installing by gem install command, Try sample/sample.rb with your Ruby. You can get it soon.

## Known Bugs
**Important Note:** Plock depends on [sourcify](https://github.com/ngty/sourcify) (so far), it has a big restriction:

- Can't use on REPLs such as pry, irb and so on: you have to use p/pp in a source code saved on the disk.
- You can put p-with-block ONLY ONCE PER LINE. Otherwise you'll get Sourcify::MultipleMatchingProcsPerLineError.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
