//@ts-check
const shell = require('shelljs');

shell.config.fatal = true;

/**
 * @param {{location?: string, debugMode?: boolean, monorepo?: boolean}} [opts]
 * @param {string} [projectName]
*/
function initProject(projectName, opts) {
  try {
    buildApp(projectName, opts)
  } catch (error) {
    console.log('Whoops, something went wrong')
    console.log(error)
    if (opts.debugMode) { return }
    cleanUp(projectName, opts)
  }
}

/**
 * @param {string} [name]
 * @param {{location?: string, debugMode?: boolean, monorepo?: boolean}} [opts]
*/
function cleanUp(name, opts) {
  shell.echo(`Cleaning up ${name}`)

  let installLocation = undefined

  if (opts && opts.location) {
    installLocation = opts.location
  } else {
    installLocation = name
  }

  shell.rm('-rf', installLocation)
}

/**
 * @param {{location?: string, debugMode?: boolean, monorepo?: boolean}} [opts]
 * @param {string} [projectName]
*/
function buildApp(projectName, opts) {
  //TODO: We might want to do a better job sanitizing input?
  const sanitizedName = projectName.replace(' ', '_')
  const pascalCaseName = snakeToPascal(sanitizedName)
  let installLocation = undefined

  if (opts && opts.location) {
    installLocation = opts.location
  } else {
    installLocation = `../${sanitizedName}`
  }

  shell.echo(`Creating ${sanitizedName}`)
  shell.echo(snakeToPascal(sanitizedName))

  const templateLocation = shell.pwd()

  shell.cp('-r', `${templateLocation}/.`, installLocation)

  shell.cd(installLocation)

  shell.echo(`Substituting stimulus_cable_ready for ${sanitizedName} and HeadwayRailsTemplate for ${pascalCaseName}`)

  shell.exec(`export LC_ALL=C && grep -rl 'stimulus_cable_ready' . | xargs sed -i '' 's/stimulus_cable_ready/${sanitizedName}/g'`)
  shell.exec(`export LC_ALL=C && grep -rl 'HeadwayRailsTemplate' . | xargs sed -i '' 's/HeadwayRailsTemplate/${pascalCaseName}/g'`)

  shell.mv('app/javascripts/stimulus_cable_ready.js', `app/assets/javascripts/${sanitizedName}.js`)
  shell.mv('app/assets/stylesheets/stimulus_cable_ready.scss', `app/assets/stylesheets/${sanitizedName}.scss`)

  shell.exec(`rvm \`cat .ruby-version\` do rvm gemset create ${sanitizedName}`)
  shell.exec(`rvm \`cat .ruby-version\` do rvm use \`cat .ruby-version\`@${sanitizedName} && gem install bundler -v '> 2.0' && bundle`)

  if (opts.monorepo) { return }
  initGit()
}

function initGit() {
  shell.exec(`
if [[ -d ".git" ]]; then
  echo "Removing .git folder"
  rm -rf .git
fi`
  )
  shell.echo("Initializing a new git repo")
  shell.exec('git init')
  shell.exec('git add .');
  shell.exec('git commit -m "Initial commit"');
}

/**
 * @param {string} [string]
*/
function snakeToPascal(string) {
  return string.split('_').map((str) => {
    return upperFirst(
      str.split('/')
      .map(upperFirst)
      .join('/'));
  }).join('');
}

/**
 * @param {string} [string]
*/
function upperFirst(string) {
  return string.slice(0, 1).toUpperCase() + string.slice(1, string.length);
}

module.exports.default = initProject;
