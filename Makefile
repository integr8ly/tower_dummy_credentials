SHELL=/bin/bash

sync:
	scripts/sync.sh ${releasetag}

clean:
	scripts/clean.sh ${branch}