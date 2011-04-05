current todo:

- Ship default herdictArrays as plists, overwrite when fresh arrays are received.
- Find out whether I should be releasing subviews in viewDidUnload as opposed to dealloc.
- Hook up the ModalVCs for for 'Info' and 'My ISP'.
- Right now we are relying on web API callbacks happening in time to fill up arrays that I try to access either way.  Need to protect for that.
	Alerts - No Connectivity
	Notice in upper corner of map: "Feed updated: mm dd HH:MM UTC".... though only when the feed is > 1 hour old and a new one can't be gotten.
		Generally, check for > 1 hour feed age, and update when that is found.
	Caching of last sessions's reportFeed, so it can be reused.
- Memory management
	...go through local vars for any that are retained and never released properly.
- Splash screen, icon
- Think carefully about performance: when a user taps, what can be presented to them immediately so that the state during any lag is an intuitive one?

Future todo:

- Color the siteSummary depending on Herdometer.
- Add 'Watched Sites' tab (should be straightforward)