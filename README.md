# Lzyboi - Linux tool for efficient command management

NOTE: Main script is located at /harbor/automation/lboi.sh. Explained in lower sections.
<br/><br/>

## DESCRIPTION
Lzyboi is a (currently) Linux-only tool allowing a user to create a datadumps (substitute name for workspace) and store information, mainly commands,
inside of it and manage said information with ease and efficiency.

This tool serves a very similar purpose to the msfconsole workspace management system, though it was not originally designed after it.
<br/><br/>

## FEATURES
### Datadumps
  - Context-specific workspaces 
  - Appendable variables for automatic population of commands where "T" = "Target" (T_IP, T_PORT, T_URL, etc...)
  - Useful for offensive security
  
### Command management
  - Storing commands into a json file
  - Categorization of commands
<br/><br/>

## UPCOMING CHANGES
**Change the bash tool-explorer for a python menu made with [Curses](https://docs.python.org/3/howto/curses.html)**<br/>
: *The current algorithm made in bash is over-complicated, non-flexible and doesn't fit the task. I might use it somewhere else though.*
  - Command storage system : Bash → Json (ex.: nmap.sh → nmap.json)
  - User-friendly GUI with QoL features (searching, categorization, adding/editing/deleting)
  - Optimization
<br/><br/>

**QoL**<br/>
: *Features ideas that would facilitate the usage of Lzyboi.*
  - "TEMPLATE" variable for better, more managable variable populating (ex.: "TEMPLATE": "{$TOOL}{$OPTIONS}{$OUTPUT}{$SUFFIXES}{$PIPES}")
<br/><br/>

**Mode enabling**<br/>
: *I want there to be a feature allowing the user to switch between modes. (ex.: Offsec, output managing (1/2/3), and more)*
  - Saving to datadump (workspace) settings
  - Indication of selected mode
<br/><br/>

**Windows adaptation**<br/>
: *Will look into this once I got something fully functionnal.*
<br/><br/>

**Manuals**<br/>
: *Lzyboi lacks documentation*
  - Updating of help page
  - Installation process (automation would be nice)
  - Enumeration of dependencies
<br/><br/>

# Additional information
This is a personnal project of mine still in very early development.

For context, I am currently planning to create a personal "workspace" directory for Linux which would consist of various tools, projects and notes,
all integrated in a modular and optimal fashion so as to avoid co-dependancy as much as possible whenever preferable. Basically, make something, that
is easy to triffle with (except the code, because I enjoy coding like a clown on things like this). The ultimate goal of this project is to minimize 
redundancy, accelerate annoying processes and facilitate Linux daily-driving.

Will update over time.
