current todo:

- Hook up the ModalVC for 'My ISP'.
- 'No Connectivity' alert
- Memory management.. go through local vars for any that are retained and never released properly.
	- Find out whether I should be releasing subviews in viewDidUnload as opposed to dealloc.
- Splash screen, icon

Future todo:

- Color the siteSummary depending on Herdometer.
- Add 'Watched Sites' tab (should be straightforward)
- Cache each sessions's reportFeed.. Notice in corner of map, or on Info view, with reportFeed timestamp.