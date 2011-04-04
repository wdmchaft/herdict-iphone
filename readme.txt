current todo:

- VC_ReportSite:
	UIAlert when you're done, and dump user out on Check Site
- Hook up the ModalVCs for for 'Info' and 'My ISP'.
- Give theSiteSummary access to theCountry... lost it somehow.
- Right now we are relying on web API callbacks happening in time to fill up arrays that I try to access either way.  Need to protect for that.
	Alerts - No Connectivity
	Notice in upper corner of map: "Feed updated: mm dd HH:MM UTC".... though only when the feed is > 1 hour old and a new one can't be gotten.
		Generally, check for > 1 hour feed age, and update when that is found.
	Caching of last sessions's reportFeed, so it can be reused.

Future todo:

- Color the siteSummary depending on Herdometer.
- Add 'Watched Sites' tab (should be straightforward)