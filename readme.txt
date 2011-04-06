current todo:

- Splash screen, icon
- Minor memory management checks:
	- go one more time through local vars for any that are retained and never released properly.
	- find out whether I should be releasing subviews in viewDidUnload as opposed to dealloc.

future todo:

- Color the siteSummary depending on Herdometer.
- Add 'Watched Sites' tab (should be straightforward)
- Cache each sessions's reportFeed.. Notice in corner of map, or on Info view, with reportFeed timestamp.