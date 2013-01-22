Convert a Movable Type export to Jekyll

Script written to convert an old Movable Type export for myself for hosting on Github Pages, seemed useful enough to release. Certain pieces of the export are intentionally skipped and not preserved in the migration (e.g. comments, pings, trackbacks, etc). Feel free to fork and add anything missing.

Loosely inspired by https://github.com/stmpjmpr/anaheim/blob/master/bin/mt_export_to_jekyll.rb

## Usage

```
% ./mt2jekyll /path/to/mt/export
```

*Note:* assumes script is located at the root of your Jekyll directory.