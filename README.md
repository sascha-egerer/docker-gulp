# This is just a temporary repository for sharing

## Docker container for gulp tasks (styleguide, visual testing ...)

A container that provides the frontend stuff in a docker environment.
It's related to https://github.com/SC5/sc5-styleguide and 
https://github.com/SC5/sc5-styleguide-visualtest

Current requirements in your folder structure:
This folder must live in to work with the current pathes
`typo3_extension/Resources/Private/Build/Docker/Styleguide`
A gulp file must exist in `typo3_extension/Resources/Private/`.
The gulp tasks have to be adjusted in the Makefile (for test and upate)

To make life a little bit easier a Makefile has been added with the
following commands:

* make base
 * Build the base container image. This stepp installs all the required
 software and building it could take some minutes.
* make update
 * Create a new container, based on the base container, with the latest
 working copy. If you do local changes run this command to have a up to
 date container.
* make test
 * Run the CSS regression tests. A styleguide and phantomjs will be
 started in the container and the regression tests will run inside of
 the container. Folders are mounted into the container to get the report
 in the `gemini-report` folder.
 *You can limit this task to a special section by defining the
 `section` variable like
 `make section=1.1.1 test`
* make update
 * The same as `make test` but it updated the regression images.
 The `section` variable can also be used here.
