# Build directory

This is the output directory of the build process.
Directory structure is inspired by the Android build system:

- `outputs/` for final files ready for use, like pdf and epub files
- `intermediates/` for processed files not yet a final output, might bight be altered manually, like Scribus files
- `generated/` for basic files and generated files, like translated docbook files
- `reports/` for build reports and logging
- `tmp/` for temporary working directories as part of the build process
