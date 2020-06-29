# rubocop:disable all
step_definition_dir = "#{File.expand_path('../../features', File.dirname(__FILE__))}/step_definitions"

f = File.new("#{File.expand_path('../../public', File.dirname(__FILE__))}/cuke_steps.html", 'w')

f << <<~EOF
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset="utf-8">

      <title>Cuke Steps</title>

      <style type='text/css'>
        *{
          font-family: courier new, helvetica, arial, san-serif;
          font-size: 14px;
        }
        table{
          margin: 0px auto;
          border-right: 1px solid #e2e2e2;
        }
        table tr th{
          border-top: 1px solid #c0c0c0;
          border-left: 1px solid #e2e2e2;
          background: #474747;
          color: #dedede;
        }
        table tr td{
          border-top: 1px solid #e2e2e2;
          border-left: 1px solid #e2e2e2;
        }
        table th{
          padding: 5px;
        }
        table tr td{
          padding: 6px 10px;
        }
        table tr:last-child td{
          border-bottom: 1px solid #c0c0c0;
        }
        .filename td{
          color: #00F;
          border-top: 1px solid #c0c0c0;
          background: #f4f4f4;
        }
        .filename .no_border{
          border-left: none;
        }
        .first_line_match td{
          border-top: 1px solid #c0c0c0;
        }
      </style>
    </head>
    <body>
      <div style='text-align: center;'>
        Last Updated: #{Time.now.strftime('%b %-d %Y - %-l:%M%P')}
      </div>

      <br>

      <table cellspacing=0 cellpadding=0>
        <tr>
          <th>Regex</th>
          <th class=''>Step Def Args</th>
          <th>Modifiers</th>
        </tr>
EOF

ignore_files = %w[]

ignore, files = Dir.glob(File.join(step_definition_dir, '**/*.rb')).partition do |file|
  ignore_files.include?(file.split('/').pop.to_s)
end

files.each_with_index do |step_file, index|
  begin
    f << <<-EOF
      <tr class='filename filename_#{index}'>
        <td align='center'>#{step_file.split('/').pop}</td>
        <td class='no_border'></td>
        <td class='no_border'></td>
      </tr>
    EOF

    index = 0
    File.new(step_file).read.each_line do |line|
      @line = line
      next unless line.match?(/^\s*(?:Given|When|Then)\(/)
      index += 1
      matches = /(Given|When|Then)(?:\(\/\^)(.*)(?:\$\/\))([imxo]*)\s*do(?:.*\|(.*)\||(?:.*))/.match(line).captures
      matches << step_file
      f << <<-EOF
      <tr class='#{index == 1 ? 'first_line_match' : ''}'>
        <td>#{matches[0]} #{matches[1]}</td>
        <td class='no_border'>#{matches[3]}</td>
        <td>#{matches[2]}</td>
      </tr>
      EOF
    end
  rescue => e
    raise "#{e} - #{@line}"
  end
end

f << <<-EOF
    </table>
  </body>
</html>
EOF
