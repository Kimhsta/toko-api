<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Barang extends Model
{
    use HasFactory;
    protected $primaryKey = 'nobarcode';
    public $incrementing = false;
    protected $keyType = 'string';

    protected $fillable = ['nobarcode', 'nama', 'stok', 'harga'];
}
