# Can you reformat these nested hashes nicely?

{:a=>{:b=>'"c"',:d=>'e',},:f=>{:g=>'{',:h=>"i",},:j=>{:k=>'\'\\}',:l=>'m',}}

# e.g.

{
 :a => { :b => '"c"',   :d => 'e', }, 
 :f => { :g => '{',     :h => "i", }, 
 :j => { :k => '\'\\}', :l => 'm', }
}

# Or, can you make these nested arrays line up vertically on commas and decimal points, with whitespace around commas but not decimal points?

[[1.0,15.35,2.5,3.7],
[10,5.7,0.201,3.1415],]

# as

[
 [  1.0, 15.35, 2.5,   3.7    ],
 [ 10,    5.7,  0.201, 3.1415 ],
]
