# Hypatia Standard Library

### What is this?

The Hypatia Standard Library is a set of defines, helpers and macros - related to core BYOND DM features - that are used across the codebase.

It's modelled after the C++ std and was initially inspired by the file structure of the Goonstation branch of SS13.

### What's included?

Something should be included in the Hypatia Standard Library if:
* It's a common compiler-level, linter-level or SpacemanDMM feature. IE: ```RETURN_TYPE()```, ```VAR_FINAL```.
* It's an extension or feature for a core DM type. IE: ```/proc/mutable_appearance()```, ```/image/proc/add_overlay()```.
* It's a macro that's pretending to be a language built-in. IE: ```isnotnull()```, ```subtypesof()```.
* It's a define related to a core BYOND feature. IE: ```SCALING_MODE_NORMAL```, ```SECONDS```.
* It's a generally useful helper macro that's codebase-agnostic. IE: ```GET_TURF()```, ```RANGE_TURFS()```.

### Licensing

The code for the Hypatia Standard Library is licensed under the [GNU Affero General Public License v3](https://www.gnu.org/licenses/agpl.html), which can be found in [/LICENSE](/LICENSE). Relevant information can also be found in [/COPYING](/COPYING).