# :nocov:
if Rails.env.development?
  # rubocop:disable Metrics/LineLength
  task :set_annotation_options do
    # Just some example settings from annotate 2.6.0.beta1
    Annotate.set_defaults(
      'position_in_routes'   => 'after',
      'position_in_class'    => 'after',
      'position_in_test'     => 'after',
      'position_in_fixture'  => 'after',
      'position_in_factory'  => 'after',
      'show_indexes'         => 'true',
      'simple_indexes'       => 'false',
      'model_dir'            => 'app/models',
      'include_version'      => 'false',
      'require'              => '',
      'exclude_tests'        => 'false',
      'exclude_fixtures'     => 'false',
      'exclude_factories'    => 'false',
      'ignore_model_sub_dir' => 'false',
      'skip_on_db_migrate'   => 'false',
      'format_bare'          => 'true',
      'format_rdoc'          => 'false',
      'format_markdown'      => 'false',
      'sort'                 => 'true',
      'force'                => 'false',
      'trace'                => 'false',
      'wrapper_open'         => 'rubocop:disable Metrics/LineLength, Lint/UnneededCopDisableDirective',
      'wrapper_close'        => 'rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective',
    )
  end
  # rubocop:enable Metrics/LineLength

  # Annotate models
  task :annotate do
    puts 'Annotating models...'
    system 'bundle exec annotate -p after -i --force'
  end
end
